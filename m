Return-Path: <linux-kernel-owner+w=401wt.eu-S1762605AbZBYWyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762605AbZBYWyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbZBYWxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:53:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56767 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZBYWxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:53:50 -0500
Message-ID: <49A5CBF7.9000501@zytor.com>
Date: Wed, 25 Feb 2009 14:53:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ATA support for 4k sector size
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>
In-Reply-To: <1235600698-6446-1-git-send-email-matthew@wil.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> The two patches following this add support for drives which have sector
> sizes other than 512 bytes.  I haven't been able to test this as I don't
> have the hardware.
> 
> Individual host drivers will have to be updated to support sizes other
> than 512 bytes.
> 
> Support for logical sector sizes that differ from physical sector sizes
> depends on the READ CAPACITY 16 patch I posted in December that isn't in
> scsi-misc yet.
> 
> The approach I've taken to generating the tables of which commands need
> a 512-byte transfer size and which use the drive's sector size command is
> 'innovative'.  Review is encouraged ;-)

What sector size do we report to user space for this?  I'm asking 
because logical sector size is visible in most partition formats.

	-hpa
