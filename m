Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbXI1Sm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbXI1Sm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbXI1Smt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:42:49 -0400
Received: from verein.lst.de ([213.95.11.210]:48053 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054AbXI1Sms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:42:48 -0400
Date: Fri, 28 Sep 2007 20:42:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: jblunck@suse.de
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de,
       agruen@suse.de, tiwai@suse.de
Subject: Re: [patch 10/10] Make set_fs_{root,pwd} take a struct path
Message-ID: <20070928184245.GJ14269@lst.de>
References: <20070927141200.820970144@X40.localnet> <20070927141229.273280043@X40.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927141229.273280043@X40.localnet>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 04:12:10PM +0200, jblunck@suse.de wrote:
> In nearly all cases the set_fs_{root,pwd}() calls work on a struct
> path. Change the function to reflect this and use path_get() here.

Looks good.

