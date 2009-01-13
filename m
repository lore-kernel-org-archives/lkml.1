Return-Path: <linux-kernel-owner+w=401wt.eu-S1759940AbZAMNZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940AbZAMNZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbZAMNZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:25:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:17305 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833AbZAMNZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:25:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NVyuJPSJncgZjClH6ffR0f9vZkMmhgGsqe9qboYRcQRwXx3idgm9yTGCT+cynWHCO/
         ZkxEDwO3PshfXyJullxx2uEHG/SdtZwouz9i4H4MkaRFtIZO0rWc+zHpr2JO/JWTl16S
         mNDnDo49IshTZMKiSqbtvZCuSWRZ8tw2rEOG4=
Date: Tue, 13 Jan 2009 16:25:28 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - include linux/types.h instead of
	asm/types.h
Message-ID: <20090113132528.GF7682@localhost>
References: <20090113120905.GB7682@localhost> <20090113125705.GC7682@localhost> <20090113125928.GA31147@elte.hu> <20090113131020.GD7682@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113131020.GD7682@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Tue, Jan 13, 2009 at 04:10:20PM +0300]
...
| | > 
| | > well... on the other hand I'm not sure if it's really
| | > a good idea to include linux/types.h where we need only
| | > __u[8,16] and so on definitions.
| | 
| | Well, linux/types.h is supposed to be a 'lightweight', 'core data types 
| | only' kind of header file, so including it is not wrong per se.
| | 
| | Sam, is there some other preferred way perhaps to resolve these?
| | 
| | 	Ingo
| | 
| 
| Until such a file not passed to some *.S. For example for e820.h
| we have it included to arch/x86/boot/header.S but fortunately
| we're bound by __ASSEMBLY__. So there linux/types.h shouldn't hurt.
| Will check others and report then.
| 
| 		- Cyrill -

ok, have checked -- this patch seems to be safe.

		- Cyrill -
