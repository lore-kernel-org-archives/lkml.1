Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbXITUCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbXITUCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbXITT5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:57:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54563 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbXITT5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:57:15 -0400
Date: Thu, 20 Sep 2007 20:57:11 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 03/25] give may_open() a local 'mnt' variable
Message-ID: <20070920195711.GA28765@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070920195249.852667D5@kernel> <20070920195252.BE019DC4@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920195252.BE019DC4@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 12:52:52PM -0700, Dave Hansen wrote:
> 
> First of all, this makes the structure jumping look a little
> bit cleaner.  So, this stands alone as a tiny cleanup.  But,
> we also need 'mnt' by itself a few more times later in this
> series, so this isn't _just_ a cleanup.

You're touching permission, not may_open, though.

