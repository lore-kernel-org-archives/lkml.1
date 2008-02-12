Return-Path: <linux-kernel-owner+w=401wt.eu-S1760319AbYBLXnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319AbYBLXnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYBLXm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:42:58 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:60503 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbYBLXm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:42:57 -0500
Date: Wed, 13 Feb 2008 00:42:56 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: David Miller <davem@davemloft.net>
cc: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
In-Reply-To: <20080212.153836.166202106.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0802130040350.14275@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802121518500.21102@fbirervta.pbzchgretzou.qr>
 <200802120935.20437.chris.mason@oracle.com>
 <Pine.LNX.4.64.0802121543240.21102@fbirervta.pbzchgretzou.qr>
 <20080212.153836.166202106.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 12 2008 15:38, David Miller wrote:
>
>> I still don't like the idea of btrfs trying to be smarter than a user
>> who can partition up his system according to
>> 	(a) his likes
>> 	(b) system or hardware requirements or recommendations
>> to align the superblock to a specific location.
>
>All of your beliefs are unfortunately without the understanding
>of restrictions that exist in several partition layouts such
>as the Sun disk label one.

(Time for Sun to switch!)

>You have to start the superblock somewhere other than zero or
>else you lose a huge chunk of your disk, and furthermore a
>zero based partition is what all of the Sun disk label
>creating programs make by default.
>
>"I make a default disk label, I put btrfs or XFS on there, my disk
> label is gone."
>
>Real intuitive.
>

x86 MSDOS partition table layout starts counting with sector 1, which
is (not so intuitively) starting at 0x7e00 (and there's no sector 0,
probably for safety). Well, each ptable format with its own quirks.
