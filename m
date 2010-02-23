Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab0BWNBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 08:01:20 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54211 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab0BWNBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 08:01:18 -0500
Date: Tue, 23 Feb 2010 14:01:28 +0100
From: Borislav Petkov <bp@amd64.org>
To: viresh kumar <viresh.linux@gmail.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: QUERY: Inclusion of header files in kernel header files
Message-ID: <20100223130128.GB30382@aftab>
References: <22dbbef21002222241h711402f1me6b60ac7502cccd4@mail.gmail.com>
 <22dbbef21002222243s7afb8e2cy1c783a29fe22ac55@mail.gmail.com>
 <20100223065953.GB32503@liondog.tnic>
 <22dbbef21002222331o6a59dc25mea3fc7e62dae6710@mail.gmail.com>
 <20100223095025.GA18559@liondog.tnic>
 <22dbbef21002230337i104c63dcm5d59064ca48a07f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22dbbef21002230337i104c63dcm5d59064ca48a07f0@mail.gmail.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: viresh kumar <viresh.linux@gmail.com>
Date: Tue, Feb 23, 2010 at 05:07:47PM +0530

> >> I think, ideally including any header file shouldn't give compilation
> >> errors for types used in
> >> included header file.
> >
> > Agreed.
> >
> > I'd send a patch fixing the bus.h header, in case no one has a valid
> > technical reason against it.
> >
> 
> That will be great!!!

Just to make sure: with "I'd" I meant "I would", i.e. actually _you_
could send a patch fixing that by explaining the problem in the commit
message :).

> Actually this issue is not present only in bus.h, but some other
> kernel header files.
> Like: arch/arm/include/asm/clkdev.h don't include list.h file but
> using struct list_head
> 
> May be we need to check this in other header files also.

Well, you should talk to the arm maintainer about that task and whether
it is desirable.

-- 
Regards/Gruss,
Boris.
