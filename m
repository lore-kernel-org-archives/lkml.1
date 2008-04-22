Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYDVLjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYDVLjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 07:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbYDVLje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 07:39:34 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22939 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbYDVLjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 07:39:33 -0400
Date: Tue, 22 Apr 2008 13:39:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [2.6 patch] select ATA_SFF
Message-ID: <20080422113927.GA12774@kernel.dk>
References: <20080421213147.GH2633@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421213147.GH2633@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22 2008, Adrian Bunk wrote:
> Making ATA_SFF a user-visible option with the drivers needing it
> depending on it caused the following problems:
> - people lose their driver when accidentally disabling it
> - people not requiring it needlessly enable it
> 
> Fortunately, we don't have to bother the user with this option at all
> since we can simply select it when it's required.

Hear hear, the newly introduced ATA_SFF config is a mess, this is much
better.

-- 
Jens Axboe

