Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZBAQd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZBAQd3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 11:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZBAQdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 11:33:17 -0500
Received: from verein.lst.de ([213.95.11.210]:49183 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbZBAQdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 11:33:16 -0500
Date: Sun, 1 Feb 2009 17:33:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com, hch@lst.de,
       serue@us.ibm.com, "David C. Hansen" <haveblue@us.ibm.com>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       sukadev@us.ibm.com
Subject: Re: [RFC][PATCH] devpts: Must release s_umount on error
Message-ID: <20090201163301.GD3416@lst.de>
References: <20090129063330.GB22898@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129063330.GB22898@us.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 10:33:30PM -0800, Sukadev Bhattiprolu wrote:
> 
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Wed, 28 Jan 2009 16:57:12 -0800
> Subject: [RFC][PATCH] devpts: Must release s_umount on error
> 
> We should drop the ->s_umount mutex if an error occurs after the
> sget()/grab_super() call. This was introduced when adding support
> for multiple instances of devpts and noticed during a code review/reorg.

Looks good and should probably be submitted for 2.6.29.

