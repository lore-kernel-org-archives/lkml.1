Return-Path: <linux-kernel-owner+w=401wt.eu-S933987AbYBOOcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987AbYBOOcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757810AbYBOOb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:31:56 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45777 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756795AbYBOObz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:31:55 -0500
Date: Fri, 15 Feb 2008 14:24:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH 0/4] ide: generic packet command representation
Message-ID: <20080215142401.2857852d@core>
In-Reply-To: <Pine.LNX.4.64.0802151503580.30301@fbirervta.pbzchgretzou.qr>
References: <1202718880-1793-1-git-send-email-petkovbb@gmail.com>
	<200802120109.24152.bzolnier@gmail.com>
	<Pine.LNX.4.64.0802151503580.30301@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, why is ide-scsi still in the tree? Is there some use case besides
> cdrecord? (Which can use /dev/hda already without the ide-scsi blob...)

With old IDE only ide-scsi can handle some of the more obscurely weird
devices, and some tape drives fail with ide-tape but work with  ide-scsi
+ osst/st.

Alan
