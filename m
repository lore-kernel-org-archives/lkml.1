Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZAMPHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZAMPHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZAMPGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:06:54 -0500
Received: from mail-fx0-f26.google.com ([209.85.220.26]:47488 "EHLO
	mail-fx0-f26.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbZAMPGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:06:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=meJiXYPL/jkincKamxz2vzb1S3ZQrJhvhIEai8UfIa3ik4lbc9kReisjvAQyrl21mY
         5VHFb8hc21q0qTEDuFwVW4UWCTP8Dr6xgCcqH5bAdLLuMlREmc+SNWcp919EPOaDK9ZV
         YQDGxYMLb31meMhl/+/dKbbBLWsTbBCwZr3y4=
Date: Tue, 13 Jan 2009 18:06:51 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - include linux/types.h instead of
	asm/types.h
Message-ID: <20090113150651.GK7682@localhost>
References: <20090113120905.GB7682@localhost> <20090113125705.GC7682@localhost> <20090113125928.GA31147@elte.hu> <20090113131020.GD7682@localhost> <20090113144505.GA4488@elte.hu> <20090113144956.GJ7682@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113144956.GJ7682@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Tue, Jan 13, 2009 at 05:49:56PM +0300]
| [Ingo Molnar - Tue, Jan 13, 2009 at 03:45:05PM +0100]
| ...
| | > 
| | > Until such a file not passed to some *.S. For example for e820.h we have 
| | > it included to arch/x86/boot/header.S but fortunately we're bound by 
| | > __ASSEMBLY__. So there linux/types.h shouldn't hurt. Will check others 
| | > and report then.
| | 
| | Any reason to not protect types.h with #ifndef __ASSEMBLY__ ?
| | 
| | 	Ingo
| | 
| 
| hmm... good question :) letme check
| 
| 		- Cyrill -

Dunno Ingo, it's dubious. I don't like the idea
to start including types.h into any kind of *.S
with #ifndef __ASSEMBLY__ protection. We export it
into user space and I don't remember if it mentioned
somewhere that user is not allowed to use -D__ASSEMBLY__.

Someone more experienced (then me) in this area should
asked first :-)

		- Cyrill -
