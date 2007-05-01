Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbXEAFYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbXEAFYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbXEAFYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:24:05 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754176AbXEAFYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:24:03 -0400
Date: Mon, 30 Apr 2007 22:23:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 hangs in boot (netconsole)
Message-Id: <20070430222348.de258c98.akpm@linux-foundation.org>
In-Reply-To: <20070430221624.dcc7346b.randy.dunlap@oracle.com>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<20070429220132.951cdf7f.randy.dunlap@oracle.com>
	<20070429222354.63265e3f.akpm@linux-foundation.org>
	<20070430081653.60fab0a5.randy.dunlap@oracle.com>
	<20070430165101.6463fee1.randy.dunlap@oracle.com>
	<20070430171229.d514ba19.akpm@linux-foundation.org>
	<46368DC3.5070503@oracle.com>
	<20070430180821.eb269fe3.akpm@linux-foundation.org>
	<20070501034330.GJ25929@bingen.suse.de>
	<20070430221624.dcc7346b.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 22:16:24 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > > I was hitting the same thing on i386 uniprocessor, but I thought it got
> > > fixed.
> > 
> > Yes.
> 
> Fixed where?  Merged into mainline or in your firstfloor patches?

The bug is in firstfloor only, and the fix (if present) will be there too.

<checks>

Nope,

ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/sched-clock-share

is identical to

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/broken-out/x86_64-mm-sched-clock-share.patch


