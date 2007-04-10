Return-Path: <linux-kernel-owner+w=401wt.eu-S1030332AbXDJVoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030332AbXDJVoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbXDJVov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:44:51 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47923 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753807AbXDJVoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:44:32 -0400
Date: Tue, 10 Apr 2007 22:46:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, Theodore Tso <tytso@mit.edu>,
       =?UTF-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Message-ID: <20070410224626.6f5239f4@the-village.bc.nu>
In-Reply-To: <17947.64947.649081.411561@notabene.brown>
References: <20070407233037.GA16508@infradead.org>
	<46193048.6000606@zytor.com>
	<20070408184129.GA20871@lazybastard.org>
	<20070408191955.GD29180@thunk.org>
	<46194260.3050900@zytor.com>
	<20070409014426.GA18580@thunk.org>
	<20070409110927.GA23240@lazybastard.org>
	<1176121897.6210.8.camel@heimdal.trondhjem.org>
	<20070409131918.GC18580@thunk.org>
	<1176127395.6210.34.camel@heimdal.trondhjem.org>
	<20070410135641.GG13650@thunk.org>
	<1176215836.14442.37.camel@heimdal.trondhjem.org>
	<17947.64947.649081.411561@notabene.brown>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> A READDIR request contains either a cookie or a filename.  Either mean
> "This identifies the last name I got from you, give me the next one".
> 
> Is there something that makes that interface problematic?

Another client may have removed the name and re-added a new file with
that name. At this point most file systems may not have placed it at the
same spot in the directory.
