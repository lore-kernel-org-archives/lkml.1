Return-Path: <linux-kernel-owner+w=401wt.eu-S1760991AbXHGJqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991AbXHGJqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 05:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758270AbXHGJqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 05:46:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:58076 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758133AbXHGJqj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 05:46:39 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX19vbvUT9ZNv9kJpAieUyKfw1FeBFIMoScpdpdYgt9
	ZTp9dGyRsQ+X2S
From: Dimitrios Apostolou <jimis@gmx.net>
To: =?utf-8?q?Rafa=C5=82_Bilski?= <rafalbilski@interia.pl>
Subject: Re: high system cpu load during intense disk i/o
Date: Tue, 7 Aug 2007 12:43:51 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200708031903.10063.jimis@gmx.net> <46B7C18E.1050008@gmx.net> <46B83560.2060107@interia.pl>
In-Reply-To: <46B83560.2060107@interia.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708071243.52430.jimis@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 August 2007 12:03:28 Rafał Bilski wrote:
> >> Just tested (plain curiosity).
> >> via82cxxx average result @533MHz:
> >> /dev/hda:
> >> Timing cached reads:   232 MB in  2.00 seconds = 115.93 MB/sec
> >> Timing buffered disk reads:   64 MB in  3.12 seconds =  20.54 MB/sec
> >> pata_via average result @533MHz:
> >> /dev/sda:
> >> Timing cached reads:   234 MB in  2.01 seconds = 116.27 MB/sec
> >> Timing buffered disk reads:   82 MB in  3.05 seconds =  26.92 MB/sec
> >
> > Interesting! I haven't tried libata myself on that system, I only have
> > remote access to it so I'm a bit afraid...
>
> Just change root=/dev/hda1 to append="root=/dev/sda1" in lilo.conf.
> And change fstab. If You don't change "/" then system will go into single
> user mode after reboot.
>
> > Rafal, I hope that system you run hdparm on isn't the archlinux one! Is
> > it easy to load an old kernel (even two years old) and do the same test?
> > If it is, please let me know of the results.
>
> I don't think it is possible. If I remember right kernel can't be older
> then glibc kernel headers.
> Btw. My disk is 20GB 2,5" ATA33. I wonder how 26MB/s is possible. I don't
> expect more.

Aha! So perhaps libata gives even greater performance benefit for better 
drives. I'll try to get local access to my PC and try it. Thanks. 


Dimitris

