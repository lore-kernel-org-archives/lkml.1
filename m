Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbYHRNxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbYHRNxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 09:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbYHRNxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 09:53:34 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17106 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbYHRNxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 09:53:33 -0400
Subject: Re: Btrfs v0.16 released
From: Chris Mason <chris.mason@oracle.com>
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0808162215320.4532@dhcppc2>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
	 <1218100464.8625.9.camel@twins>
	 <1218105597.15342.189.camel@think.oraclecorp.com>
	 <877ias66v4.fsf@basil.nowhere.org>
	 <1218221293.15342.263.camel@think.oraclecorp.com>
	 <1218747656.15342.439.camel@think.oraclecorp.com>
	 <20080814211756.GC13814@one.firstfloor.org>
	 <1218763554.15342.460.camel@think.oraclecorp.com>
	 <20080815013934.GE19125@one.firstfloor.org>
	 <1218805256.15342.484.camel@think.oraclecorp.com>
	 <Pine.LNX.4.61.0808162215320.4532@dhcppc2>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 09:52:09 -0400
Message-Id: <1219067529.2137.1.camel@think.oraclecorp.com>
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

On Sat, 2008-08-16 at 22:26 +0300, Szabolcs Szakacsits wrote:
> On Fri, 15 Aug 2008, Chris Mason wrote:
> 
> > Ext3 and XFS score somewhere between 10-15MB/s on the same test...
> 
> Interesting (and cool animations). 
> 
> We tried compilebench (-i 30 -r 0) just for fun using kernel 2.6.26, 
> freshly formatted partition, with defaults. Results:
> 
>               MB/s    Runtime (s)
>              -----    -----------
>   ext3       13.24        877
>   btrfs      12.33        793


Thanks for running things.

The code in the btrfs-unstable tree has all my performance fixes.
You'll need it to get good results.  Also, the MB/s number doesn't
include the time to run sync at the end, which is probably why the
runtime for btrfs is shorter but MB/s is lower.

-chris


