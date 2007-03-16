Return-Path: <linux-kernel-owner+w=401wt.eu-S965104AbXCPOXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965104AbXCPOXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964865AbXCPOXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:23:01 -0400
Received: from ozlabs.org ([203.10.76.45]:57655 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965104AbXCPOXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:23:00 -0400
Date: Fri, 16 Mar 2007 09:20:34 -0500
From: Anton Blanchard <anton@samba.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Ashif Harji <asharji@cs.uwaterloo.ca>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] mm/filemap.c: unconditionally call mark_page_accessed
Message-ID: <20070316142034.GA5962@kryten>
References: <Pine.GSO.4.64.0703081612290.1080@cpu102.cs.uwaterloo.ca> <20070312142012.GH30777@atrey.karlin.mff.cuni.cz> <20070312143900.GB6016@wotan.suse.de> <20070312151355.GB23532@duck.suse.cz> <Pine.GSO.4.64.0703121247210.7679@cpu102.cs.uwaterloo.ca> <20070312173500.GF23532@duck.suse.cz> <Pine.GSO.4.64.0703131438580.8193@cpu102.cs.uwaterloo.ca> <20070313185554.GA5105@duck.suse.cz> <Pine.GSO.4.64.0703141218530.28958@cpu102.cs.uwaterloo.ca> <1173905741.8763.36.camel@kleikamp.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173905741.8763.36.camel@kleikamp.austin.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> I guess the downside to this is if a reader is reading a large file, or
> several files, sequentially with a small read size (smaller than
> PAGE_SIZE), the pages will be marked active after just one read pass.
> My gut says the benefits of this patch outweigh the cost.  I would
> expect real-world backup apps, etc. to read at least PAGE_SIZE.

PAGE_SIZE being 8k on sparc, 16-64k on ia64 and potentially 64kb on
powerpc :)

Id expect a large percentage of files to be below that size.

Anton
