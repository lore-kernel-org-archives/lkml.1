Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYKWSn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYKWSn4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 13:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYKWSnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 13:43:46 -0500
Received: from qb-out-0506.google.com ([72.14.204.226]:28027 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYKWSnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 13:43:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=akzZaM6c5TbfnmVWK80b67LSfDX1lCPXZtgO6mMuxVL+nLp7to9a34zmyxci1QUBvb
         ANXdNKs3N9vhT8jAUq5B5ufMT+ib9U/JLw8swAlaGkFL3RNzK8ULHRjQMCuzgGLo4YZv
         OKyM8sDq5GDtzngm4LJ1GYMUPmgYxQvfQ7ZZw=
Date: Sun, 23 Nov 2008 21:43:44 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce ENTRY(KPROBE)_X86  assembly helpers
	to catch unbalanced declaration
Message-ID: <20081123184344.GJ12710@localhost>
References: <20081123165711.GA12710@localhost> <20081123175125.GA32472@uranus.ravnborg.org> <20081123175846.GF12710@localhost> <20081123181248.GA338@uranus.ravnborg.org> <20081123182103.GH12710@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123182103.GH12710@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Nov 23, 2008 at 09:21:03PM +0300]
| [Sam Ravnborg - Sun, Nov 23, 2008 at 07:12:48PM +0100]
| ...
| | > 
| | > I don't have -next tree on my laptop, neither cross-compile tools but
| | > if someone could test it -- it would be great. But I used gas macros
| | > here -- i doubt other architectures has the same syntax. At least
| | > PDP-11 would beat us with ';' symbol :)
| | 
| | If we include this in any of the 100+ trees that Stephen sucks
| | into -next we will get it tried out.
| | 
| | Ingo has so and so does others so getting it into -next
| | is rather easy. Then the automated builds will tell of if
| | it fails on any of the toolchains used there.
| | 
| | 	Sam
| | 
| 
| Sam, to be clear, you mean that I could put this stuff into general
| include/linux/linkage.h with general names as ENTRY/END and the same
| for KPROBE so it could be merged into -next tree for testing? If yes,
| that as I said there will be a lot of errors so build will stuck in
| a moment 'cause of unbalanced ENTRY. Not sure if it's a good idea :)
| 
| 		- Cyrill -

Did I understand you right? It's highly possible I could translate
message the wrong way somime.

		- Cyrill -
