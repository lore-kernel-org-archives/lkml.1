Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbXCRQuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbXCRQuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 12:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbXCRQuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 12:50:05 -0400
Received: from smtp.nokia.com ([131.228.20.173]:46069 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbXCRQuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 12:50:04 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Matt Mackall <mpm@selenic.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <20070318162720.GI10459@waste.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
	 <20070318162720.GI10459@waste.org>
Content-Type: text/plain; charset=utf-8
Date: Sun, 18 Mar 2007 18:49:39 +0200
Message-Id: <1174236579.17249.6.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 18 Mar 2007 16:49:39.0912 (UTC) FILETIME=[6B85FC80:01C7697D]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070318184941-21168BB0-4D105701/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-18 at 11:27 -0500, Matt Mackall wrote:
> Forgive my ignorance, but why did you not implement the two features
> above as device mapper layers instead? A device mapper can arbitrarily
> transform I/O addresses and contents and has direct access to the
> mapped device's ioctl interfaces, etc.

Just because UBI is designed for flash devices, not block devices. Note,
UBI is not for MMC/USB stick/SC/etc flashes, which are used as block
devices, but for _bare_ flashes.

Please, glance here to find more information about the different between
flashes and block devices:

http://www.linux-mtd.infradead.org/faq/general.html#L_mtd_vs_hdd

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

