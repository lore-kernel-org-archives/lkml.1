Return-Path: <linux-kernel-owner+w=401wt.eu-S1763693AbYBODOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763693AbYBODOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 22:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYBODOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 22:14:35 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:27911 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYBODOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 22:14:34 -0500
Date: Thu, 14 Feb 2008 19:13:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chris Snook <csnook@redhat.com>
Cc: Tony Breeds <tony@bakeyournoodle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next build status
Message-Id: <20080214191328.75b6e1bf.randy.dunlap@oracle.com>
In-Reply-To: <47B4FEBC.2020700@redhat.com>
References: <20080215114253.ddf3f929.sfr@canb.auug.org.au>
	<47B4E9CB.3090708@redhat.com>
	<20080215020511.GJ6887@bakeyournoodle.com>
	<47B4FEBC.2020700@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 21:53:48 -0500 Chris Snook wrote:

> Tony Breeds wrote:
> > On Thu, Feb 14, 2008 at 08:24:27PM -0500, Chris Snook wrote:
> >> Stephen Rothwell wrote:
> >>> Hi all,
> >>>
> >>> Initial status can be seen here
> >>> http://kisskb.ellerman.id.au/kisskb/branch/9/ (I hope to make a better
> >>> URL soon).  Suggestions for more compiler/config combinations are
> >>> welcome, but we can't necessarily commit to fulfilling all you
> >>> wishes.  :-)
> >>>
> >> i386 allmodconfig please.
> > 
> > Wont i386 allmodconfig be equivalent to x86_64 allmodconfig?
> 
> Only if there are no bugs.
> 
> Driver code is most likely to trip over bitness/endianness bugs, and 
> you've already got allmodconfig builds for be32, be64, and le64 
> architectures.  Adding an le32 architecture (i386) completes the 
> coverage of these basic categories.

x86_64 doesn't compile ISA drivers (last time I checked).
Could be a few other subtle differences.

---
~Randy
