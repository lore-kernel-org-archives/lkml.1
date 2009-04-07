Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbZDGRou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbZDGRou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757885AbZDGRoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:44:38 -0400
Received: from verein.lst.de ([213.95.11.210]:52601 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757003AbZDGRoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:44:38 -0400
Date: Tue, 7 Apr 2009 19:44:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] romfs: cleanup romfs_fs.h
Message-ID: <20090407174417.GC14462@lst.de>
References: <20090407160708.GA11384@lst.de> <20090407174457.GA13089@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407174457.GA13089@uranus.ravnborg.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 07:44:57PM +0200, Sam Ravnborg wrote:
> On Tue, Apr 07, 2009 at 06:07:08PM +0200, Christoph Hellwig wrote:
> > There's no kernel-only content in it anymore, so move it to header-y
> > and remove the superflous #ifdef __KERNEL__.
> 
> today there is no difference between header-y and unifdef-y.
> We pass everything through unifdef these days.

The __KERNEL__ removal still applies, and as long as we have two
different variables it should use the correct one.

But why do you send all through unifdef anyway?  That's a pretty bad
signal to send when we try to get people to do cleanly seprated headers.

