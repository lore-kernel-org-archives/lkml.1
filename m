Return-Path: <linux-kernel-owner+w=401wt.eu-S932771AbYETR0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbYETR0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765407AbYETR0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:26:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37788 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765233AbYETRZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:25:57 -0400
Date: Tue, 20 May 2008 10:22:59 -0700
From: Greg KH <greg@kroah.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: akpm@linux-foundation.org, matthew@wil.cx, kay.sievers@vrfy.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3][-mm] reclassify the sg_sysfs_class mutex
Message-ID: <20080520172259.GB11666@kroah.com>
References: <20080520095851.GB3201@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520095851.GB3201@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 05:58:51PM +0800, Dave Young wrote:
> [Please first apply the patch 1/3 before this]
> 
> To please lockdep here we use class_reclassify to change
> the lock class of sg_sysfs_class

Are you suggesting we do this for every struct class in the kernel?  If
so, why not just do it in the class core, instead of having to modify
every single caller?

I don't think the overall idea of this patch set is acceptable anyway :(

thanks,

greg k-h
