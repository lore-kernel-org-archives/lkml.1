Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbYIJOH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbYIJOH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYIJOHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:07:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54922 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYIJOHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:07:14 -0400
Date: Wed, 10 Sep 2008 10:07:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Chris Leech <christopher.leech@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       devel@open-fcoe.org, jfs-discussion@lists.sourceforge.net
Subject: Re: [PATCH 1/3] 24-bit types: typedef and macros for accessing
	3-byte arrays as integers
Message-ID: <20080910140712.GA12280@infradead.org>
References: <20080905165732.16689.50256.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905165732.16689.50256.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 09:57:32AM -0700, Chris Leech wrote:
> Both iSCSI and Fibre Channel make use of 24-bit big-endian values in
> frame headers.  This patch defines __be24 and __le24 typedefs for a
> structure wrapped around a 3-byte array, and macros to convert back and
> forth to a 32-bit integer.
> 
> The undefs in iscsi_proto.h are because of the different calling
> convention for the existing hton24 macro in the iSCSI code.  iSCSI will
> be converted in a subsequent patch.

JFS already defines an __le24, see fs/jfs/endian24.h.  Please try to
cover it, too or at least make sure you don't break it.

