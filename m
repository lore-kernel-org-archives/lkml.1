Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbXDEQYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbXDEQYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 12:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbXDEQYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 12:24:41 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:39153 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbXDEQYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 12:24:40 -0400
Date: Thu, 5 Apr 2007 09:25:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@canonical.com
Subject: Re: [PATCH] HPA support: Revised patch
Message-Id: <20070405092520.9bad0c45.randy.dunlap@oracle.com>
In-Reply-To: <20070405141352.12fddb6e@the-village.bc.nu>
References: <20070405141352.12fddb6e@the-village.bc.nu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007 14:13:52 +0100 Alan Cox wrote:

> This one should fix the problems with slave devices and the Macintosh hang

s/Performa/Perform/g

> +/**
> + *	ata_read_native_max_address_ext	-	LBA48 native max query
> + *	@dev: Device to query
> + *
> + *	Performa an LBA48 size query upon the device in question. Return the
> + *	actual LBA48 size or zero if the command fails.
> + */
> +
> +static u64 ata_read_native_max_address_ext(struct ata_device *dev)
> +{
> +}
> +
> +/**
> + *	ata_read_native_max_address	-	LBA28 native max query
> + *	@dev: Device to query
> + *
> + *	Performa an LBA28 size query upon the device in question. Return the
> + *	actual LBA28 size or zero if the command fails.
> + */
> +
> +static u64 ata_read_native_max_address(struct ata_device *dev)
> +{
> +}


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
