Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbZAMOuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbZAMOuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbZAMOt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:49:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:40929 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbZAMOt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:49:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Qd9BcUesgqU6X0qwf5xffzzuQNTR/whdSntDVr0SIy5dpN2/CmljVKAmqeB74er4Ot
         InitpWRa2Hh2MCZic2+NudIbdu9L6Dgq/vBFrAKGHNnJfojAgM0Zj2lnjgoMNbZzEEgc
         YVHKkQJU3MgF93nl0+jcrJNuMchxLjHWZxjts=
Date: Tue, 13 Jan 2009 17:49:56 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - include linux/types.h instead of
	asm/types.h
Message-ID: <20090113144956.GJ7682@localhost>
References: <20090113120905.GB7682@localhost> <20090113125705.GC7682@localhost> <20090113125928.GA31147@elte.hu> <20090113131020.GD7682@localhost> <20090113144505.GA4488@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113144505.GA4488@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Tue, Jan 13, 2009 at 03:45:05PM +0100]
...
| > 
| > Until such a file not passed to some *.S. For example for e820.h we have 
| > it included to arch/x86/boot/header.S but fortunately we're bound by 
| > __ASSEMBLY__. So there linux/types.h shouldn't hurt. Will check others 
| > and report then.
| 
| Any reason to not protect types.h with #ifndef __ASSEMBLY__ ?
| 
| 	Ingo
| 

hmm... good question :) letme check

		- Cyrill -
