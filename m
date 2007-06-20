Return-Path: <linux-kernel-owner+w=401wt.eu-S1761181AbXFTMcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761181AbXFTMcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 08:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbXFTMcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 08:32:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43918 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763AbXFTMcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 08:32:24 -0400
Date: Wed, 20 Jun 2007 13:32:23 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] Union mount documentation.
Message-ID: <20070620123223.GB4620@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jan Blunck <jblunck@suse.de>, linux-kernel@vger.kernel.org
References: <20070620055050.GB4267@in.ibm.com> <20070620055157.GC4267@in.ibm.com> <1182319191.2700.9.camel@laptopd505.fenrus.org> <f5al1i$foi$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5al1i$foi$1@sea.gmane.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 07:29:55AM +0000, Jan Blunck wrote:
> Mounting a file system twice is bad in the first place. This should be
> done by using bind mounts and bind a mounted file system into a union.
> After that the normal locking rules apply (and hopefully work ;).

>From the kernel POV mounting a filesystem twice is the same as doing
a bind mount.
