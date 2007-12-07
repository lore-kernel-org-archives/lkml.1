Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbXLGWB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbXLGWB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 17:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbXLGWBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 17:01:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62634 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbXLGWBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 17:01:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
Date: Fri, 7 Dec 2007 23:01:38 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop>
In-Reply-To: <20071207211425.10223.91240.sendpatchset@balbir-laptop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712072301.38723.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX196dOdGiuUETWURcAQm5PThS2MLFUM2iiH6Z5f
 DJrAarFETrDZUkNzoCWy08jqsNfDrq9gto08iWX46zAJB6m//U
 DyFCWBz3LH5OtX5p/UBoA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 December 2007, Balbir Singh wrote:
> Here's a dumb simple implementation of fake NUMA nodes for PowerPC. Fake
> NUMA nodes can be specified using the following command line option
> 
> numa=fake=<node range>
> 
> node range is of the format <range1>,<range2>,...<rangeN>

Excellent idea! I'd love to have this in RHEL5u1, because that would make
that distro boot on certain machines that have more memory than is supported
without an iommu driver. The problem we have is that when you simply
say mem=1G but all of the first gigabyte is on the first node, you end
up with a memoryless node, which is not supported.

Unfortunately, it comes too late for me now, as all new distros already boot
on Cell machines that need an IOMMU.

	Arnd <><
