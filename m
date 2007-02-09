Return-Path: <linux-kernel-owner+w=401wt.eu-S1946509AbXBIPH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946509AbXBIPH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946508AbXBIPH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:07:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37044 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946510AbXBIPH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:07:57 -0500
Subject: Re: [PATCH] Don't include linux/mtd/map.h from linux/mtd/physmap.h
From: David Woodhouse <dwmw2@infradead.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-mtd@lists.infradead.org, Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070209153029.1ffe2420@dhcp-252-105.norway.atmel.com>
References: <20070209153029.1ffe2420@dhcp-252-105.norway.atmel.com>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 15:07:50 +0000
Message-Id: <1171033670.29713.51.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 15:30 +0100, Haavard Skinnemoen wrote:
> Replace the inclusion of linux/mtd/map.h with a forward-declaration
> of struct map_info. This allows linux/mtd/physmap.h to be included by
> e.g. board code even if the MTD subsystem is disabled.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com> 

Applied; thanks.

-- 
dwmw2

