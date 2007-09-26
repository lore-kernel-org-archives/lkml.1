Return-Path: <linux-kernel-owner+w=401wt.eu-S1759532AbXIZNpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbXIZNpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbXIZNpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:45:04 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57026 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbXIZNpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:45:01 -0400
Date: Wed, 26 Sep 2007 09:44:15 -0400
Message-Id: <200709261344.l8QDiFdw025498@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH 05/25] Unionfs: cast page->index loff_t before shifting 
In-reply-to: Your message of "Wed, 26 Sep 2007 09:31:21 BST."
             <20070926083121.GA8421@infradead.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20070926083121.GA8421@infradead.org>, Christoph Hellwig writes:
> On Tue, Sep 25, 2007 at 11:09:44PM -0400, Erez Zadok wrote:
> > Fixes bugs in number promotion/demotion computation, as per
> > <http://lkml.org/lkml/2007/9/20/17>
> 
> It's better to use te page_offset helper as that avoids any confusion
> on where to cast.

Excellent.  Will do.

Erez.
