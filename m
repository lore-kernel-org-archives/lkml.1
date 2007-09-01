Return-Path: <linux-kernel-owner+w=401wt.eu-S1751818AbXIAAB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbXIAAB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 20:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbXIAABR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 20:01:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59393 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbXIAABQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 20:01:16 -0400
Subject: Re: [RFC 1/4] Large Blocksize support for Ext2/3/4
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: clameter@sgi.com
Cc: linux-fsdevel@vger.kernel.org, adilger@clusterfs.com, sho@tnes.nec.co.jp,
       ext4 development <linux-ext4@vger.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1188434857.3799.76.camel@localhost.localdomain>
References: <20070828190551.415127746@sgi.com>
	 <20070828190735.292638294@sgi.com>
	 <1188432669.3799.35.camel@localhost.localdomain>
	 <1188434857.3799.76.camel@localhost.localdomain>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 31 Aug 2007 17:01:30 -0700
Message-Id: <1188604890.3837.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-29 at 17:47 -0700, Mingming Cao wrote:

> Just rebase to 2.6.23-rc4 and against the ext4 patch queue. Compile tested only. 
> 
> Next steps:
> Need a e2fsprogs changes to able test this feature. As mkfs needs to be
> educated not assuming rec_len to be blocksize all the time.
> Will try it with Christoph Lameter's large block patch next.
> 

Two problems were found when testing largeblock on ext3.  Patches to
follow. 

Good news is, with your changes, plus all these extN changes, I am able
to run ext2/3/4 with 64k block size, tested on x86 and ppc64 with 4k
page size. fsx test runs fine for an hour on ext3 with 16k blocksize on
x86:-)

Mingming

