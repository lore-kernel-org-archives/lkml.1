Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbYKWS7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbYKWS7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 13:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbYKWS7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 13:59:21 -0500
Received: from qb-out-0506.google.com ([72.14.204.227]:27864 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYKWS7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 13:59:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eCqsaRj37XsQXuzNuVUIRajmm7OJFMeN2L7x49Iue40fd3g+xiqIp/fZFxtkNRjmmu
         mMpot3DflCEwSju+Rn40X45AYydX2MFqkDcxgqMc6HTByBUZagqEwikD/xYr1nF0Qtt8
         Kqw8Z5eDnAAsXUixAIzsjUvieNsH0AC9IF/2k=
Date: Sun, 23 Nov 2008 21:59:19 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce ENTRY(KPROBE_ENTRY)_X86  assembly
	helpers to catch unbalanced declaration v3
Message-ID: <20081123185919.GM12710@localhost>
References: <20081123172139.GC12710@localhost> <20081123173015.GE12710@localhost> <20081123185726.GB21106@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123185726.GB21106@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Nov 23, 2008 at 07:57:26PM +0100]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > | Impact: improvements
| > | 
| > | It's usefull to catch unbalanced or messed or mixed declarations of ENTRY and
| > | KPROBES. These macros would help a bit.
| 
| applied to tip/x86/irq, thanks Cyrill.
| 
| Now lets try a patch that makes use of it in the entry*.S files, and 
| see the fallout?
| 
| 	Ingo
| 

OK, let me fetch your branch first :)

		- Cyrill -
