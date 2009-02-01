Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbZBAQfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbZBAQfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 11:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZBAQez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 11:34:55 -0500
Received: from verein.lst.de ([213.95.11.210]:49198 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbZBAQez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 11:34:55 -0500
Date: Sun, 1 Feb 2009 17:34:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       hpa@zytor.com, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org,
       sukadev@us.ibm.com
Subject: Re: [RFC][PATCH 1/5] Unroll essentials of do_remount_sb() into devpts
Message-ID: <20090201163440.GE3416@lst.de>
References: <20090129064259.GA23160@us.ibm.com> <20090129064547.GB23160@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129064547.GB23160@us.ibm.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.349 () BAYES_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 10:45:47PM -0800, Sukadev Bhattiprolu wrote:
> +	fsi = DEVPTS_SB(s);
> +	opts = &fsi->mount_opts;
> +	parse_mount_options(data, PARSE_REMOUNT, opts);

You could probably get rid of at least the fsi variable without making the
code less readable.  Independent of these cosmetic bits the patch looks
good to me.

