Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbYACAk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbYACAk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbYACAkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:40:17 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:31932 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbYACAkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:40:16 -0500
Date: Wed, 02 Jan 2008 18:40:08 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] ide: delete filenames/versions from comments
In-reply-to: <fa.CAem1qRl3AG/KJjVoPZU/Cn8U1g@ifi.uio.no>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <477C2EE8.50301@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.CAem1qRl3AG/KJjVoPZU/Cn8U1g@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Delete filenames/versions from comments.
> 
> I'm leaving decisions about adding DRV_VERSION defines and MODULE_VERSION()-s
> to maintainers of the respective drivers.
> 
> While at it:
> 
> * Remove unused VERSION define from ide.c.
> 
> * Remove unused/stale DRV_VERSION define from au1xxx-ide.c.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

How about getting rid of this stupid thing in drivers/ide/ide.c:

#define	REVISION	"Revision: 7.00alpha2"

which is used in:

printk(KERN_INFO "Uniform Multi-Platform E-IDE driver " REVISION "\n");

It's been 7.00alpha2 for god knows how long, so clearly this version 
number is not useful..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

