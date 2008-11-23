Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYKWSVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYKWSVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 13:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYKWSVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 13:21:07 -0500
Received: from qb-out-0506.google.com ([72.14.204.234]:21810 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYKWSVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 13:21:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KbCoeCbllehggmzK6+2WxcsJpfPBn2X620jBSXxUZAYRRPBUAxR6SuZk4WhTV9YrUp
         yOz1TJj//diPRGGsdSPB+9VZPPXpkril+UX1b6vSJEnzpTnGQ27AW4Ayuuu0fqn1LcO+
         i3j/ne90FXnA3YBViKt+b4Yb4JPv2rcz9AcDM=
Date: Sun, 23 Nov 2008 21:21:03 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce ENTRY(KPROBE)_X86  assembly helpers
	to catch unbalanced declaration
Message-ID: <20081123182103.GH12710@localhost>
References: <20081123165711.GA12710@localhost> <20081123175125.GA32472@uranus.ravnborg.org> <20081123175846.GF12710@localhost> <20081123181248.GA338@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123181248.GA338@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Sun, Nov 23, 2008 at 07:12:48PM +0100]
...
| > 
| > I don't have -next tree on my laptop, neither cross-compile tools but
| > if someone could test it -- it would be great. But I used gas macros
| > here -- i doubt other architectures has the same syntax. At least
| > PDP-11 would beat us with ';' symbol :)
| 
| If we include this in any of the 100+ trees that Stephen sucks
| into -next we will get it tried out.
| 
| Ingo has so and so does others so getting it into -next
| is rather easy. Then the automated builds will tell of if
| it fails on any of the toolchains used there.
| 
| 	Sam
| 

Sam, to be clear, you mean that I could put this stuff into general
include/linux/linkage.h with general names as ENTRY/END and the same
for KPROBE so it could be merged into -next tree for testing? If yes,
that as I said there will be a lot of errors so build will stuck in
a moment 'cause of unbalanced ENTRY. Not sure if it's a good idea :)

		- Cyrill -
