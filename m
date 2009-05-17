Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZEQT1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZEQT1X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 15:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbZEQT1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 15:27:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:52699 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753367AbZEQT1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 15:27:12 -0400
X-Authenticated: #10801262
X-Provags-ID: V01U2FsdGVkX1+s2cswW2msZZAMtB3s3EsinnYR+VHHn7U/5E2JKc
	9MZlZgOmx1Fm78
Date: Sun, 17 May 2009 21:27:07 +0200
From: Richard Atterer <richard@2009.atterer.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Elias Oltmanns <eo@nebensachen.de>
Subject: Re: s2disk hangs with kernel >=2.6.29, SATA, Gigabyte EG45M-DS2H
	(bisected)
Message-ID: <20090517192707.GA6110@arbonne.lan>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Elias Oltmanns <eo@nebensachen.de>
References: <20090516225153.GA7883@arbonne.lan> <4A0F7FC2.5090109@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A0F7FC2.5090109@garzik.org>
Mail-Copies-To: nobody
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 11:08:50PM -0400, Jeff Garzik wrote:
> Does it work if you disable CONFIG_IDE, and use only CONFIG_ATA for PATA?

Yes, it works fine then!

I had to disconnect my PATA data drive to avoid the disks from being 
renumbered before I could test without CONFIG_IDE.

(But I then double-checked with the broken CONFIG_IDE=m kernel: The failure 
happens independently of whether the second PATA drive is connected or 
not.)

Cheers,

  Richard

-- 
  __   _
  |_) /|  Richard Atterer     |  GnuPG key: 888354F7
  | \/¯|  http://atterer.net  |  08A9 7B7D 3D13 3EF2 3D25  D157 79E6 F6DC 8883 54F7
  ¯ '` ¯
