Return-Path: <linux-kernel-owner+w=401wt.eu-S934242AbXILCGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934242AbXILCGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 22:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934150AbXILCGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 22:06:37 -0400
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:43818 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934056AbXILCGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 22:06:36 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC] Union Mount: Readdir approaches 
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org,
       Jan Blunck <jblunck@suse.de>
In-Reply-To: <20070911165547.GA26515@filer.fsl.cs.sunysb.edu>
References: <20070907054618.GD1692@in.ibm.com> <E1ITYJK-0000xP-8h@jroun> <20070907075855.GG1692@in.ibm.com> <20070907173941.GB20360@filer.fsl.cs.sunysb.edu> <E1IUYpP-0000z6-BS@jroun> <20070911165547.GA26515@filer.fsl.cs.sunysb.edu>
Date: Wed, 12 Sep 2007 11:05:56 +0900
Message-Id: <E1IVHc4-0000qa-9z@jroun>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


"Josef 'Jeff' Sipek":
> So, if I understand correctly, you create the entire block as if you were
> going to write to disk? Unionfs keeps the data in a linked list.

Basically yes.
But the dir block in cache has no hole which is contiguous memory.


Junjiro Okajima
