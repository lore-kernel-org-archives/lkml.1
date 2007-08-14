Return-Path: <linux-kernel-owner+w=401wt.eu-S934679AbXHNCZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934679AbXHNCZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 22:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbXHNCZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 22:25:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58954 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbXHNCZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 22:25:31 -0400
Date: Tue, 14 Aug 2007 04:25:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stewart Smith <stewart@mysql.com>
Cc: Brice Figureau <brice+lklm@daysofwonder.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070814022529.GA11322@one.firstfloor.org>
References: <20070803123712.987126000@chello.nl> <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org> <20070804063217.GA25069@elte.hu> <loom.20070805T190600-28@post.gmane.org> <p734pjdmxsz.fsf@bingen.suse.de> <1186389638.30448.29.camel@localhost.localdomain> <1187055897.18858.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187055897.18858.31.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 11:44:56AM +1000, Stewart Smith wrote:
> > Since the database fits in RAM, the only kind of access Mysql is doing
> > is writing to the innodb log, the mysql binlog and finally to the innodb
> > database files.
> > There are certainly a whole lot of fsync'ing happening.
> 
> yes. Keep in mind that the binlog grows in file size too... so this has
> to sync all the metadata as well (ick, i know).

It might be an interesting experiment to see if it still happens
with the file system remounted as ext2. ext2 has a much more 
benign fsync than ext3.

-Andi
