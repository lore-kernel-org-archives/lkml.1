Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbXCEEXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbXCEEXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 23:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXCEEXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 23:23:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56267 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbXCEEXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 23:23:34 -0500
Date: Mon, 5 Mar 2007 04:23:22 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
       alex@clusterfs.com, suzuki@in.ibm.com,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Message-ID: <20070305042322.GA22584@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Anton Altaparmakov <aia21@cam.ac.uk>, Arnd Bergmann <arnd@arndb.de>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com,
	Ulrich Drepper <drepper@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org> <200703032345.33137.arnd@arndb.de> <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0DA8B217-DDD4-4E05-B000-DEBE3BE55B94@cam.ac.uk>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 08:11:17PM +0000, Anton Altaparmakov wrote:
> glibc cannot ever be smart enough because a file system driver will  
> always know better and be able to do things in a much more optimized  
> way.

Please read the thread again.  That is not what anyone proposed.
The issues we're discussing is whether fallback for a filesystem that
does not support preallocation natively should be done in kernelspace
or in userspace.

