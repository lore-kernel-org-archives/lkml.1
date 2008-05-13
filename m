Return-Path: <linux-kernel-owner+w=401wt.eu-S1759835AbYEMMmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbYEMMmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbYEMMmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:42:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42526 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYEMMmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:42:04 -0400
Date: Tue, 13 May 2008 08:42:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       util-linux-ng@vger.kernel.org
Subject: Re: [BUG] remount ro on loopback mount leaves unmountable
	filesystem behind
Message-ID: <20080513124203.GA4806@infradead.org>
References: <20080513085047.GY155679365@sgi.com> <20080513102340.GA15112@infradead.org> <20080513120710.GA155679365@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513120710.GA155679365@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 10:07:10PM +1000, David Chinner wrote:
> Anyway, I'll hard code loop device numbers into the script so
> I can just forget about this problem. Thanks, Christoph.

hardcoding them is a little dangerous because a system might aswell
have them in use already, e.g. for CD images.  Just use losetup -f to
find the first free one and keep it in a shell variable.
