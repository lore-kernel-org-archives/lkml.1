Return-Path: <linux-kernel-owner+w=401wt.eu-S965906AbXIGOjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965906AbXIGOjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 10:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965470AbXIGOjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 10:39:10 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52860 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965508AbXIGOjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 10:39:09 -0400
Date: Fri, 7 Sep 2007 16:39:08 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, Jan Blunck <jblunck@suse.de>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: Re: [RFC] Union Mount: Readdir approaches
In-Reply-To: <20070907054618.GD1692@in.ibm.com>
Message-ID: <Pine.LNX.4.64.0709071637180.25942@fbirervta.pbzchgretzou.qr>
References: <20070907054618.GD1692@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 7 2007 11:16, Bharata B Rao wrote:

>Questions
>---------
>The main problem in getting a sane readdir() implementation in Union Mount
>is the fact that a single vfs object (file structure) is used to represent
>more than one (underlying) directory. Because of this, it is unclear as to
>how lseek(2) needs to behave in such cases.
>
>First of all, should we even expect a sane lseek(2) on union mounted
>directories ? If not, will the Approach 2, which works uniformly for
>all filesystem types be acceptable ?

Filesystems also have this problem. http://lkml.org/lkml/2007/4/7/107
If you ask me, we should entriely do away with the telldir/seekdir
blackmagic (and add appropriate compat code).



	Jan
-- 
