Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbZDFFov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbZDFFov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 01:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZDFFo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 01:44:28 -0400
Received: from kroah.org ([198.145.64.141]:47440 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751872AbZDFFo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 01:44:26 -0400
Date: Sun, 5 Apr 2009 22:34:45 -0700
From: Greg KH <greg@kroah.com>
To: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: david-b@pacbell.net, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [patch/rfc 2.6.29 1/2] MTD: driver model updates
Message-ID: <20090406053445.GB19096@kroah.com>
References: <200903260042.42091.david-b@pacbell.net> <a95a62fe0904021641j17a7c26dv5652de4a19bad662@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a95a62fe0904021641j17a7c26dv5652de4a19bad662@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 04:41:47PM -0700, Kevin Cernekee wrote:
> Here is a follow-up patch to apply on top of David Brownell's original
> MTD driver model patch at:
> 
> http://lists.infradead.org/pipermail/linux-mtd/2009-March/025005.html
> 
> Changes:
> 
> 1) Add more sysfs attributes: mtd_flags, mtd_size, mtd_erasesize,
> mtd_writesize, mtd_oobsize, mtd_numeraseregions, mtd_name .

When adding new sysfs attributes, please add the proper
Documentation/ABI/ information as well.

thanks,

greg k-h
