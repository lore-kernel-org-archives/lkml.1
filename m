Return-Path: <linux-kernel-owner+w=401wt.eu-S1764170AbXJEW10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764170AbXJEW10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 18:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761412AbXJEW1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 18:27:19 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42776 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758729AbXJEW1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 18:27:18 -0400
Date: Sat, 6 Oct 2007 00:27:17 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [code] Unlimited partitions, a try
In-Reply-To: <4706B6A8.2060800@zytor.com>
Message-ID: <Pine.LNX.4.64.0710060022530.18723@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710051347470.13406@fbirervta.pbzchgretzou.qr>
 <4706B6A8.2060800@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 5 2007 15:11, H. Peter Anvin wrote:
> Jan Engelhardt wrote:
>> 15 partitions (at least for sd_mod devices) are too few.
>
> Now when we have 20-bit minors, can't we simply recycle some of the 
> higher bits for additional partitions, across the board?  63 
> partitions seem to have been sufficient; at least I haven't heard 
> anyone complain about that for 15 years.

GPT allows up to 128 partitions, and the linux partition code currently 
allows for up to MAX_PART (256). Assuming 1048576/128, that would give 
8192 disks. With dynamic minor allocation and reuse, all that goes away 
and the limit becomes a bit less than 1048576 _partitions_.
