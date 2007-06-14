Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbXFNJli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbXFNJli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 05:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbXFNJla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 05:41:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54290 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXFNJla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 05:41:30 -0400
Date: Thu, 14 Jun 2007 11:41:28 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: holzheu@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, gregkh@suse.de, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
Subject: Re: [RFC/PATCH] Documentation of kernel messages
Message-ID: <20070614094128.GF17819@atrey.karlin.mff.cuni.cz>
References: <1181747217.29512.9.camel@localhost.localdomain> <20070613111549.db1fa4d9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613111549.db1fa4d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  <snip>

> Your proposal is similar to one I made to some Japanese developers
> earlier this year.  I was more modest, proposing that we
> 
> - add an enhanced printk
> 
> 	xxprintk(msgid, KERN_ERR "some text %d\n", some_number);
  Maybe a stupid idea but why do we want to assign these numbers by hand?
I can imagine it could introduce collisions when merging tons of patches
with new messages... Wouldn't it be better to compute say, 8-byte hash
from the message and use it as it's identifier? We could do this
automagically at compile time. I know it also has it's problems - you
fix a spelling and the message gets a different id and you have to
update translation/documentation catalogue but maybe that could be
solved too...

								Honza
