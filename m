Return-Path: <linux-kernel-owner+w=401wt.eu-S1760427AbYFEVZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760427AbYFEVZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYFEVZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:25:39 -0400
Received: from server.drzeus.cx ([85.8.24.28]:58955 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750987AbYFEVZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:25:38 -0400
Date: Thu, 5 Jun 2008 23:25:13 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Collins <ben.collins@canonical.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       kernel-team <kernel-team@lists.ubuntu.com>
Subject: Re: [PATCH] FIx crash in mmc_block on 64-bit
Message-ID: <20080605232513.3f5cb48f@mjolnir.drzeus.cx>
In-Reply-To: <1212428359.7239.4.camel@cunning>
References: <1212428359.7239.4.camel@cunning>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2008 13:39:19 -0400
Ben Collins <ben.collins@canonical.com> wrote:

> Fairly simple. "dev_use" was being allocated as a zero length array
> because of bad math on 64-bit systems causing a crash in
> find_first_zero_bit(). One-liner follows:
> 

A signed-off-by to make things nice and proper, please. :)

You can add an Acked-by: Pierre Ossman <drzeus@drzeus.cx> and pass it
on directly to Linus.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
