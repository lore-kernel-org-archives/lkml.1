Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbYK0RET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbYK0RET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 12:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYK0RED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 12:04:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42499 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbYK0RED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 12:04:03 -0500
Date: Thu, 27 Nov 2008 12:03:46 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mingo@redhat.com, val.henson@gmail.com,
       matthew@wil.cx
Subject: Re: [PATCH v2 2/2] relatime: Allow making relatime the default
	behaviour
Message-ID: <20081127170345.GA14991@infradead.org>
References: <20081126195457.GA3541@srcf.ucam.org> <20081126195824.GB3541@srcf.ucam.org> <492DD035.5020705@oracle.com> <20081127150126.GA20941@srcf.ucam.org> <20081127150341.GB20941@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127150341.GB20941@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 03:03:41PM +0000, Matthew Garrett wrote:
> Add support for defaulting to relatime
>     
> Allow the kernel to enable relatime on all mounts by default. This can be
> configured at build time or by a kernel parameter or sysctl. Also add a
> MS_NORELATIME mount option to allow the default to be overridden for specific
> mount points.

NACK.  Please just do it in fstab.

