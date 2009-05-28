Return-Path: <linux-kernel-owner+w=401wt.eu-S1764315AbZE1Uf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764315AbZE1Uf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758354AbZE1UfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:35:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58148 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899AbZE1UfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:35:19 -0400
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
From: Peter Zijlstra <peterz@infradead.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr
In-Reply-To: <4A1E9D8B.8020908@gmail.com>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
	 <4A1E9D0B.4090402@gmail.com>  <4A1E9D8B.8020908@gmail.com>
Content-Type: text/plain
Date: Thu, 28 May 2009 22:35:08 +0200
Message-Id: <1243542908.6645.104.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 17:19 +0300, Artem Bityutskiy wrote:
> Artem Bityutskiy wrote:
> > question is - should it? 'bdi_register()' a block device,
> > but we do not have one.
> 
> Sorry, wanted to say: 'bdi_register()' registers a block
> device.

BDI stands for backing device info and is not related to block devices
other than that block devices can also be (ok, always are) backing
devices.

If you want to do writeback, you need a backing device to write to. The
BDI is the device abstraction for writeback.



