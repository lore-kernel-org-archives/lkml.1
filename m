Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbZKRSNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbZKRSNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758047AbZKRSNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:13:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43547 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757883AbZKRSNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:13:11 -0500
Date: Wed, 18 Nov 2009 18:14:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org,
       "Linux-Kernel Mailinglist" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       =?ISO-8859-14?B?RnLpZOlyaWM=?= Weisbecker <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] BKL: Remove BKL from default_llseek()
Message-ID: <20091118181433.50b1b707@lxorguk.ukuu.org.uk>
In-Reply-To: <200911181833.37531.arnd@arndb.de>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de>
	<20091118171524.4d2f8cec@lxorguk.ukuu.org.uk>
	<20091118172730.GD28723@shareable.org>
	<200911181833.37531.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complete list of offenders I can find

Stuff that just doesn't look like it can work and ought to be marked
BROKEN as it must have been non-working for ages.

drivers/scsi/osst
drives/s390/char/s390tape
arch/frv/kernel/sysctl.c
arch/cris/arch-v10/drivers/eeprom.c

Stuff that looks trivial to salvage and works if you don't pread/write I
imagine

drivers/sbus/char/flash.c

Bits in staging

rt2860
vt6656

plus some obvious mega abusers that will need cleaning up anyway in that
area.
