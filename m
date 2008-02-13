Return-Path: <linux-kernel-owner+w=401wt.eu-S1764865AbYBMBIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764865AbYBMBIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYBMBIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:08:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59849
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752288AbYBMBIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:08:42 -0500
Date: Tue, 12 Feb 2008 17:09:14 -0800 (PST)
Message-Id: <20080212.170914.58659870.davem@davemloft.net>
To: jengelh@computergmbh.de
Cc: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0802130040350.14275@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802121543240.21102@fbirervta.pbzchgretzou.qr>
	<20080212.153836.166202106.davem@davemloft.net>
	<Pine.LNX.4.64.0802130040350.14275@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Wed, 13 Feb 2008 00:42:56 +0100 (CET)

> 
> On Feb 12 2008 15:38, David Miller wrote:
> >
> >> I still don't like the idea of btrfs trying to be smarter than a user
> >> who can partition up his system according to
> >> 	(a) his likes
> >> 	(b) system or hardware requirements or recommendations
> >> to align the superblock to a specific location.
> >
> >All of your beliefs are unfortunately without the understanding
> >of restrictions that exist in several partition layouts such
> >as the Sun disk label one.
> 
> (Time for Sun to switch!)

You can go update every sparc machine's firmware then, you
can't boot off of a device that doesn't use a sun disk
label.

Your expectations are unrealistic, and it's just simpler to
do something sane and follow the majority of existing practice
by putting the superblock a few blocks into the partition.
