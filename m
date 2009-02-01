Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbZBAQim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbZBAQim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 11:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbZBAQi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 11:38:28 -0500
Received: from verein.lst.de ([213.95.11.210]:49289 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbZBAQi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 11:38:27 -0500
Date: Sun, 1 Feb 2009 17:38:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       hpa@zytor.com, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       sukadev@us.ibm.com
Subject: Re: [RFC][PATCH 5/5] Merge code for single and multiple-instance mounts
Message-ID: <20090201163807.GI3416@lst.de>
References: <20090129064259.GA23160@us.ibm.com> <20090129064753.GF23160@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129064753.GF23160@us.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 10:47:53PM -0800, Sukadev Bhattiprolu wrote:
> 
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Wed, 28 Jan 2009 19:11:15 -0800
> Subject: [RFC][PATCH 5/5] Merge code for single and multiple-instance mounts
> 
> new_pts_mount() (including the get_sb_nodev()), shares a lot of code
> with init_pts_mount(). The only difference between them is the 'test-super'
> function passed into sget().
> 
> Move the shared code into a new, common function, do_pts_mount() and
> remove new_pts_mount() and init_pts_mount() functions,

I would even merge init_pts_mount into devpts_get_sb, otherwise looks
good to me.

