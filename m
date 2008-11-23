Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbYKWTEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbYKWTEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 14:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYKWTEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 14:04:31 -0500
Received: from qb-out-0506.google.com ([72.14.204.226]:31285 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbYKWTEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 14:04:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TUWcKdS8KSucup4A8relk5fUJMCFCBMBAzK+f9A9kcEobFlWC3xzZOlBq13wmNapVI
         LLRkOZcQ4854BfMRVJcr+swzOfTiNv8Pm/1j41mpoMn0dFRael8kaljgbjOeaWDXjsRH
         9McS/B7qRV8IWC9TP9OxWswA/HXYE5lIQ9S7I=
Date: Sun, 23 Nov 2008 22:04:29 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce ENTRY(KPROBE)_X86  assembly helpers
	to catch unbalanced declaration
Message-ID: <20081123190429.GO12710@localhost>
References: <20081123165711.GA12710@localhost> <20081123175125.GA32472@uranus.ravnborg.org> <20081123175846.GF12710@localhost> <20081123181248.GA338@uranus.ravnborg.org> <20081123182103.GH12710@localhost> <20081123185417.GA21106@elte.hu> <20081123185726.GL12710@localhost> <20081123190025.GD21106@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123190025.GD21106@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Nov 23, 2008 at 08:00:25PM +0100]
...
| > 
| > So be it :) Btw I think Alexander is right -- better to use .warning 
| > instead of .error (and without .abort) even on x86. Could you update 
| > Ingo?
| 
| .error is perfectly fine because that way automated tests that we do 
| on -tip will catch any bugs, we really dont want to mis-annotate these 
| things. Warnings tend to only pile up and rarely get fixed - without 
| enforcement mechanism that causes people to fix them.
| 
| 	Ingo
| 

ok, let me try to play with this feature a bit. Will report the results.

		- Cyrill -
