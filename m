Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbYIVHr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbYIVHr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 03:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYIVHrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 03:47:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58870 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbYIVHrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 03:47:21 -0400
Date: Mon, 22 Sep 2008 03:47:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Krishna Kumar <krkumar2@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: do_generic_file_read() doesn't need to validate
	filp
Message-ID: <20080922074720.GA12452@infradead.org>
References: <20080922040325.10196.87900.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922040325.10196.87900.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 09:33:25AM +0530, Krishna Kumar wrote:
> From: Krishna Kumar <krkumar2@in.ibm.com>
> 
> do_generic_file_read() doesn't need to validate filp when accessing it. This
> is probably a remnant of an earlier code.

Looks good, thanks.

