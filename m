Return-Path: <linux-kernel-owner+w=401wt.eu-S1760155AbYHORzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155AbYHORzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 13:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180AbYHORy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 13:54:57 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:10512 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbYHORy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 13:54:56 -0400
Subject: Re: Btrfs v0.16 released
From: Chris Mason <chris.mason@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20080815134545.GM13048@mit.edu>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
	 <1218100464.8625.9.camel@twins>
	 <1218105597.15342.189.camel@think.oraclecorp.com>
	 <877ias66v4.fsf@basil.nowhere.org>
	 <1218221293.15342.263.camel@think.oraclecorp.com>
	 <1218747656.15342.439.camel@think.oraclecorp.com>
	 <20080814234458.GD13048@mit.edu>
	 <1218762627.15342.447.camel@think.oraclecorp.com>
	 <1218804361.15342.470.camel@think.oraclecorp.com>
	 <20080815134545.GM13048@mit.edu>
Content-Type: text/plain
Date: Fri, 15 Aug 2008 13:52:52 -0400
Message-Id: <1218822772.15342.503.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-15 at 09:45 -0400, Theodore Tso wrote:
> On Fri, Aug 15, 2008 at 08:46:01AM -0400, Chris Mason wrote:
> > Whoops the link above is wrong, try:
> > 
> > http://oss.oracle.com/~mason/compilebench
> 
> Thanks, I figured it out.
> 
> > It is worth noting that the end throughput doesn't matter quite as much
> > as the writeback pattern.  Ext4 is pretty solid on this test, with very
> > consistent results.
> 
> There were two reasons why I wanted to play with compilebench.  The
> first is we have a fragmentation problem with delayed allocation and
> small files getting forced out due to memory pressure, that we've been
> working for the past week. 

Have you tried this one:

http://article.gmane.org/gmane.linux.file-systems/25560

This bug should cause fragmentation on small files getting forced out
due to memory pressure in ext4.  But, I wasn't able to really
demonstrate it with ext4 on my machine.

-chris



