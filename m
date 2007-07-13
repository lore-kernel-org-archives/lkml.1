Return-Path: <linux-kernel-owner+w=401wt.eu-S1758995AbXGMM1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995AbXGMM1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 08:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757294AbXGMM1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 08:27:41 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:42440 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbXGMM1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 08:27:40 -0400
Date: Fri, 13 Jul 2007 14:27:52 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: PS3 Storage Driver O_DIRECT issue
Message-ID: <20070713122752.GA854@aepfle.de>
References: <20070704132212.726923000@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070704132212.726923000@pademelon.sonytel.be>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This driver (or the generic PS3 code) has appearently problems with
O_DIRECT. 
glibc aborts parted because the malloc metadata get corrupted. While it
is reproducible, the place where it crashes changes with every version
of the debug attempt.
I dont have a handle right now, all I know is that the metadata after a
malloc area get overwritten with zeros.


Can you have a look at this? 
parted /dev/ps3da
print (a few times)
