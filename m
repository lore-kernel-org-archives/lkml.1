Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab0BBWGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 17:06:19 -0500
Received: from 1wt.eu ([62.212.114.60]:56069 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab0BBWGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 17:06:18 -0500
Date: Tue, 2 Feb 2010 23:06:31 +0100
From: Willy Tarreau <w@1wt.eu>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Stefan Seyfried <seife@sphairon.com>
Subject: Re: [PATCH 2.4] FAT: do not continue in fat_get_block if bmap fails
Message-ID: <20100202220631.GA16098@1wt.eu>
References: <1265115635-22612-1-git-send-email-stefan.seyfried@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265115635-22612-1-git-send-email-stefan.seyfried@googlemail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stefan,

On Tue, Feb 02, 2010 at 02:00:35PM +0100, Stefan Seyfried wrote:
> From: Stefan Seyfried <seife@sphairon.com>
> 
> There is no use in continuing the write operation after fat_bmap() fails.
> (This successfully killed a VFAT FS for me).
> The corresponding code in 2.6 does return here as well, AFAICT.

OK then that's fine, I'm merging it.

Thanks!
Willy

