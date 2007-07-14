Return-Path: <linux-kernel-owner+w=401wt.eu-S1759219AbXGNHoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219AbXGNHoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 03:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbXGNHoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 03:44:10 -0400
Received: from canuck.infradead.org ([209.217.80.40]:48206 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbXGNHoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 03:44:08 -0400
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support
	features in larger inode
From: Peter Zijlstra <peterz@infradead.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20070713214746.GH23255@mami.zabbo.net>
References: <1183275482.4010.133.camel@localhost.localdomain>
	 <20070710163247.5c8bfa3f.akpm@linux-foundation.org>
	 <20070713020529.1486491f.akpm@linux-foundation.org>
	 <1184333621.20032.85.camel@twins>
	 <20070713121259.20066d5b.akpm@linux-foundation.org>
	 <20070713214746.GH23255@mami.zabbo.net>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 09:43:35 +0200
Message-Id: <1184399015.5284.34.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 14:47 -0700, Zach Brown wrote:
> > I fear the consequences of this change :(
> 
> I love it.  In the past I've lost time by working with patches which
> didn't quite realize that ext3 holds a transaction open during
> ->direct_IO.
> 
> > Oh well, please keep it alive, maybe beat on it a bit, resend it
> > later on?
> 
> I can test the patch to make sure that it catches mistakes I've made in
> the past. 

That would be much appreciated.

>  Peter, do you have any interest in seeing how far we can get
> at tracking lock_page()?  I'm not holding my breath, but any little bit
> would probably help.

Yeah I'm going to try that one next.. 

