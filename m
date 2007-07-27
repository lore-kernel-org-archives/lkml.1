Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbXG0TDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbXG0TDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 15:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759431AbXG0TDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 15:03:08 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47528 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929AbXG0TDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 15:03:07 -0400
Date: Fri, 27 Jul 2007 21:03:05 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Subbu Seetharaman <subbus@serverengines.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Source organization for two drivers sharing coomon code
In-Reply-To: <20070727171729.f3ff0878@mailhost.serverengines.com>
Message-ID: <Pine.LNX.4.64.0707272102070.16356@fbirervta.pbzchgretzou.qr>
References: <20070727171729.f3ff0878@mailhost.serverengines.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 27 2007 10:17, Subbu Seetharaman wrote:
>What is the recommended way for two drivers to share common code ?
>Our device has two PCI functions and hence two drivers -  NIC and 
>SCSI driver.   The source code for these dirvers will fit under 
>drivers/net and drivers/scsi.  But both drivers share some common 
>code.  If possible, I would like to avoid duplicating the common 
>code under the two driver directories.   Is there any recommened 
>way to organize such common  code ?  Thanks.

You could create (in total) three modules, e.g. my-common.ko,
my-net.ko and my-scsi.ko, of which the latter two use functions from the first.


	Jan
-- 
