Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbXD3McP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbXD3McP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 08:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbXD3McO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 08:32:14 -0400
Received: from brick.kernel.dk ([80.160.20.94]:10400 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbXD3McN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 08:32:13 -0400
Date: Mon, 30 Apr 2007 14:27:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CFQ IO scheduler patch series - AIM7 DBase results on a 16-way IA64
Message-ID: <20070430122753.GL21015@kernel.dk>
References: <4635D59C.4050300@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4635D59C.4050300@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30 2007, Alan D. Brunelle wrote:
> The results from a single run of an AIM7 DBase load on a 16-way ia64 box 
> (64GB RAM + 144 FC disks) showed a slight regression (~0.5%) by adding 
> in this patch. (Graph can be found at   
> http://free.linux.hp.com/~adb/cfq/cfq_dbase.png   ) It is only a single 
> set of runs, on a single platform, but it is something to keep an eye on 
> as the regression showed itself across the complete run.

Do you know if this regression is due to worse IO performance, or
increased system CPU usage?

-- 
Jens Axboe

