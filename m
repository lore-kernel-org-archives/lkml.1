Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbYBLXel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbYBLXel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYBLXeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:34:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58995
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbYBLXeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:34:13 -0500
Date: Tue, 12 Feb 2008 15:34:45 -0800 (PST)
Message-Id: <20080212.153445.118944467.davem@davemloft.net>
To: jengelh@computergmbh.de
Cc: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0802121518500.21102@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802121458420.21102@fbirervta.pbzchgretzou.qr>
	<200802120908.59602.chris.mason@oracle.com>
	<Pine.LNX.4.64.0802121518500.21102@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Tue, 12 Feb 2008 15:21:52 +0100 (CET)

> For sparc you could have something like
> 
> 			startlba	endlba	type
> 	sda1		0		2	1 Boot
> 	sda2		2		58	3 Whole disk
> 	sda3		58		90000	83 Linux
> 
> and slap the bootloader into "MBR", just like on x86.
> Or I am missing something..

You cannot specify partitions on LBA boundaries on sparc, the Sun disk
label specifies the partition start points in cylinders.
