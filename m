Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbZJNMNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbZJNMNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 08:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbZJNMNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 08:13:49 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:34594 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbZJNMNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 08:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=JirBOg7gBPMH599S2qxsWCvhx7iwvNcmdcy0NzpUXNfdGAeekE8KHWi1qNFjS1E4Dk
         5b09LdE4SHU7usk3dTPxcIOlUODUguCiJhkygeJfu+wH4nn4k550QJxly7gmaa8jgBBi
         +raRfuOD/+d2k5ubtb9bPUvdF10PZmMCrb4GM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] pata_sc1200: Fix crash on boot
Date: Wed, 14 Oct 2009 14:12:29 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc2-00279-g2ffa5fe; KDE/4.3.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
       jeff@garzik.org, linux-kernel@vger.kernel.org, stable@kernel.org,
       "Alexandros C. Couloumbis" <alex@ozo.com>, linux-ide@vger.kernel.org
References: <20091006150737.9610.81541.stgit@localhost.localdomain> <20091013185637.870369c8.akpm@linux-foundation.org> <20091014130046.0aa13166@lxorguk.ukuu.org.uk>
In-Reply-To: <20091014130046.0aa13166@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <200910141412.29467.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 October 2009 14:00:46 Alan Cox wrote:
> > This patch applies to 2.6.31 and 2.6.30 (at least).  How far back
> > should it be ported?
> 
> No idea. I was just getting it fixed for the maintainer while waiting for
> something else to build.

BTW do you happen to know who is the current maintainer of this driver
(ditto for other PATA drivers)?

MAINTAINERS lists only:

	SERIAL ATA (SATA) SUBSYSTEM
	P:      Jeff Garzik
	M:      jgarzik@pobox.com
	L:      linux-ide@vger.kernel.org
	T:      git git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
	S:      Supported
	F:      drivers/ata/
	F:      include/linux/ata.h
	F:      include/linux/libata.h

but this driver surely ain't SATA.
