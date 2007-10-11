Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbXJKMKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbXJKMKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 08:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbXJKMKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 08:10:00 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:49603 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbXJKMJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 08:09:59 -0400
From: Bernd Schubert <bs@q-leap.de>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCHES] Re: sil3114 data corruption
Date: Thu, 11 Oct 2007 14:09:55 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200710081709.18253.bs@q-leap.de> <200710101112.20448.bs@q-leap.de>
In-Reply-To: <200710101112.20448.bs@q-leap.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710111409.56210.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 October 2007 11:12:20 Bernd Schubert wrote:
> On Monday 08 October 2007 17:09:17 Bernd Schubert wrote:
> > [sorry for sending twice, but after I read the sil sources, I see the
> > mail address had been wrong]
> >
> > Hi,
> >
> > somehow the sil3114 causes data corruption with some (newer?) disks.
> > Simply filling the filesystem with zeros and reading the these data will
> > make the kernel to report filesystem corruption.
> > This is definitely not an issue of memory, since the systems (several
> > tested) do have ECC memory and the memory is monitored with EDAC.
> >
> > kernel versions tested: 2.6.15-2.6.20
>
> Update: Setting sata_sil.slow_down=1 fill fix the problem, seems there are
> some drives missing in the quirk table.
>
> Jeff, I found an old patch/workaround from you
> (http://uwsg.indiana.edu/hypermail/linux/kernel/0403.1/1957.html), can you
> give me any further information why this never went into the driver?
>

I will send 3 mails with patches to fix this corruption.


-- 
Bernd Schubert
Q-Leap Networks GmbH
