Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbYBLXiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbYBLXiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYBLXiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:38:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37101
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752411AbYBLXiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:38:05 -0500
Date: Tue, 12 Feb 2008 15:38:36 -0800 (PST)
Message-Id: <20080212.153836.166202106.davem@davemloft.net>
To: jengelh@computergmbh.de
Cc: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0802121543240.21102@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802121518500.21102@fbirervta.pbzchgretzou.qr>
	<200802120935.20437.chris.mason@oracle.com>
	<Pine.LNX.4.64.0802121543240.21102@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Tue, 12 Feb 2008 16:04:52 +0100 (CET)

> I still don't like the idea of btrfs trying to be smarter than a user
> who can partition up his system according to
> 	(a) his likes
> 	(b) system or hardware requirements or recommendations
> to align the superblock to a specific location.

All of your beliefs are unfortunately without the understanding
of restrictions that exist in several partition layouts such
as the Sun disk label one.

You have to start the superblock somewhere other than zero or
else you lose a huge chunk of your disk, and furthermore a
zero based partition is what all of the Sun disk label
creating programs make by default.

"I make a default disk label, I put btrfs or XFS on there, my disk
 label is gone."

Real intuitive.
