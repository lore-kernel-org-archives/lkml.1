Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbXKBLC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbXKBLC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 07:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbXKBLCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 07:02:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52607 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbXKBLCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 07:02:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "w.landgraf" <w.landgraf@ool.fr>
Subject: Re: kernel 2.6.24-rc1-git10 crash report
Date: Fri, 2 Nov 2007 12:19:25 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20071102082432.8665.qmail@andesite.ool.fr>
In-Reply-To: <20071102082432.8665.qmail@andesite.ool.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711021219.25648.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 2 November 2007 09:24, w.landgraf wrote:
> A detailed crash report is in your letter box
> postmaster@vger.kernel.org .  It returned steady-steady
> because was considered como spam by your mailer.
> w.landgraf www.copaya.yi.org

Can you please send a problem description, in plain text, first?

Thanks,
Rafael

 
> > > On 1/Nov/2007 21:26 werner wrote ..
> > > > On 1/Nov/2007 15:57 werner wrote ..
> > > > > Kernel Crash -- Details see below
> > > > > globc 2.7  glib2 2.14.2
> > > > > W.Landgraf
> > > > > www.copaya.yi.org
> > > > >
> =3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D=3D3D
> > > > > 2.6.24-rc1-git10
> > > > > EIP 0600: <c0407284> EFLAGS 00010212 CPU 0
> > > > > EIUP is at xor_sse_2+0x34/0x200
> > > > > EAX: 10 EBX fffedb22 ECX c183f000 EDX c183c000 ESS
> 8005003b EDI c0929614
> > EBP
> > > > c183f000
> > > > > ESP c1823ef0   
> > > > > DS 7b ES 7b FS d8 GS 0 SS 68
> > > > > Process swapper  pid 1  ti: c182200  task c1820000
> task.ti c=3D3D1822000
> > > > > Stack:  8x 0    8x 0   fffedb22  0  c04067b3  10 
> c0849b62  c1030780  c183f000
> > > > > c183c000
> > > > > call trace
> > > > > c0 4067b3 do_xor_speed+0x53/0xd0
> > > > >    9a9582 calibrate_xor_blocks 0xe2/0x100 (or 1a0 ?)
> > > > >   191594  register_filesystem =3D3D0X44/0X70
> > > > >   991565 kernel_init+0x125/0x2f0
> > > > >    10420a  ret_from_fork +0x6/0x1c  (or 0xb ...)
> > > > >   991440 kernel_init+0x0/0x2f0
> > > > >        " again
> > > > >    c0104edf  kernel_thread_helper+0x7/0x18
> > > > > code  08 89 74 24 44 0f 20 cf 0f 06 (or 0b) 0f 11 04
> 24 0f 11 4c 34 10 0f
> > 11
> > > > 54
> > > > > 24 20 0f 11 5c 24 30 0f 18 82 00
> > > > > 01 00 00 0f 18 82 20 01 00 00 <00> 20x 0
> > > > > EIP c0407284 xor_sse_2+0x34/0x200 SS ESP 068: c1823ef0
> > > > > kernel panic
> > > > >
> > 
> > THE REST OF THIS MESSAGE, SEE IN YOUR MAILBOX 
> postmaster@vger.kernel.org  BECAUSE
> > OF YOUR STUPID SPAM CONFIGURATION 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
"Premature optimization is the root of all evil." - Donald Knuth
