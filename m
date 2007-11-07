Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbXKGEJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbXKGEJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 23:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbXKGEJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 23:09:35 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:34075 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbXKGEJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 23:09:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tS1DgRyLrMDn1Jp530RGq9Cez36SfNw8crWYPRDh+vdtjAYmyPlOcnIpsT07phJ4e6hnVlpo9VBeTZ3ZpLOLQGL+ZIUvQrYbcFDKWYfGmYd/Lgfv0ZoROznQXJr0JxKHtiq1YUXvZ1JDjHNkIA1Q9Uh51cyE3pRufJYYM2lQdCM=
Message-ID: <86802c440711062009t7e98d27fqdfb466b9843da060@mail.gmail.com>
Date: Tue, 6 Nov 2007 20:09:33 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Peer Chen" <pchen@nvidia.com>
Subject: Re: [PATCH] SCSI: Add the SGPIO support for sata_nv.c
Cc: "Christoph Hellwig" <hch@infradead.org>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       "Kuan Luo" <kluo@nvidia.com>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B0C8DDCF5@hkemmail01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20061031104055.GA8898@infradead.org>
	 <15F501D1A78BD343BE8F4D8DB854566B0C8DDCF5@hkemmail01.nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 7, 2006 1:55 AM, Peer Chen <pchen@nvidia.com> wrote:
> Modified and resent out the patch as attachment.
> Description about the patch:
> Add SGPIO support in sata_nv.c.
> SGPIO (Serial General Purpose Input Output) is a sideband serial 4-wire
> interface that a storage controller uses to communicate with a storage
> enclosure management controller, primarily to control activity and
> status LEDs that are located within drive bays or on a storage
> backplane. SGPIO is defined by [SFF8485].
> In this patch,we drive the LEDs to blink when read/write operation
> happen on SATA drives connect the corresponding ports on MCP55 board.
> ==========
> The patch will be applied to kernel 2.6.19-rc4-git9.

do you have one that can apply to 2.6.24-rc2 or current linus git tree.

YH
