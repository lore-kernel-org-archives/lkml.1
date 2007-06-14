Return-Path: <linux-kernel-owner+w=401wt.eu-S1756373AbXFNWe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbXFNWe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXFNWev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:34:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60418 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbXFNWet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:34:49 -0400
Date: Thu, 14 Jun 2007 23:34:48 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, mark.fasheh@oracle.com, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: iov_iter_fault_in_readable fix
Message-ID: <20070614223448.GA28420@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
	npiggin@suse.de, mark.fasheh@oracle.com, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
References: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net> <20070613134005.GA13815@localhost.sw.ru> <20070613135759.GD13815@localhost.sw.ru> <20070614173153.GA14771@infradead.org> <20070614222109.GF86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614222109.GF86004887@sgi.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 08:21:09AM +1000, David Chinner wrote:
> Yeah, it can run a subset of the tests on NFS and UDF filesystems as well and
> there are some specific UDF-only tests in it too.  I think the NFS test group
> is mostly generic tests that don't use or test specific XFS features.

Actually most testcases can run on any reasonable posixish filesystem, we
just need some glue to tell the testsuite it's actually okay.
