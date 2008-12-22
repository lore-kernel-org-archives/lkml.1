Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbYLVQRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbYLVQRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 11:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbYLVQQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 11:16:58 -0500
Received: from verein.lst.de ([213.95.11.210]:47345 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbYLVQQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 11:16:57 -0500
Date: Mon, 22 Dec 2008 17:16:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@lst.de>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] add a vfs_fsync helper
Message-ID: <20081222161641.GA9734@lst.de>
References: <200812220143.29375.david-b@pacbell.net> <Pine.LNX.4.44L0.0812221102190.18968-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0812221102190.18968-100000@netrider.rowland.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2008 at 11:07:26AM -0500, Alan Stern wrote:
> This won't work unless vfs_fsync() is EXPORTed.

Well, it works for my static test kernel, but not for most common
configs.

Thanks, the export is obviously needed and will be in the next spin.

