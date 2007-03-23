Return-Path: <linux-kernel-owner+w=401wt.eu-S932854AbXCWTOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbXCWTOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932143AbXCWTOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:14:20 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:43198 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbXCWTOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:14:19 -0400
Date: Fri, 23 Mar 2007 20:14:28 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: request_queue_t depends on CONFIG_BLOCK
Message-ID: <20070323191428.GA23413@aepfle.de>
References: <20070322215234.GA13219@aepfle.de> <20070322215351.GA7216@infradead.org> <20070323001002.GA14583@aepfle.de> <200703231929.19406.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200703231929.19406.bzolnier@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, Bartlomiej Zolnierkiewicz wrote:

> > Because it is needed in a few places.
> 
> Is there really any PPC64 specific code which needs <linux/ide.h>
> (ppc_ide_md is used only by PPC32)?

This is about CONFIG_BLOCK=n, not about arch/... Is all non-driver
code which has to poke into ide code supposed to put an #ifdef
CONFIG_IDE around #include <linux/ide.h>?

