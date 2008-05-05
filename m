Return-Path: <linux-kernel-owner+w=401wt.eu-S1760375AbYEESur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375AbYEESur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761805AbYEESqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:46:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57181 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762815AbYEESqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:46:13 -0400
Date: Mon, 5 May 2008 14:46:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] mm/filemap.c should #include <linux/ramfs.h>
Message-ID: <20080505184610.GA23910@infradead.org>
References: <20080505182749.GJ17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505182749.GJ17139@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 09:27:50PM +0300, Adrian Bunk wrote:
> Every file should include the headers containing the externs for its 
> global code (in this case for struct generic_file_vm_ops).

Please move generic_file_vm_ops to fs.h instead please, it doesn't
belong into a fle called ramfs.h, and neither should filemap.c include
such a header.

