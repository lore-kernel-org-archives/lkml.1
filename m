Return-Path: <linux-kernel-owner+w=401wt.eu-S965606AbXCLOPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965606AbXCLOPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965880AbXCLOPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:15:06 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:60613 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965606AbXCLOPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:15:05 -0400
Message-ID: <45F5604E.5020400@s5r6.in-berlin.de>
Date: Mon, 12 Mar 2007 15:14:38 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Jan Beulich <jbeulich@novell.com>,
       Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BUILD_BUG_ON_ZERO -> BUILD_BUG_OR_ZERO
References: <1173655694.32234.213.camel@localhost.localdomain>  <45F51C25.76E4.0078.0@novell.com> <1173691510.32234.222.camel@localhost.localdomain> <45F53C4D.30802@s5r6.in-berlin.de> <Pine.LNX.4.64.0703120748310.6942@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0703120748310.6942@CPE00045a9c397f-CM001225dbafb6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Mon, 12 Mar 2007, Stefan Richter wrote:
>> Rusty Russell wrote:
>> > OTOH, BUILD_BUG_OR_ZERO says what happens: either it's a build bug, or
>> > it's zero.
>>
>> What about ZERO_UNLESS_BUILD_BUG_ON(e)? It's long though...
> 
> how often is this going to be used?  it's not like the tree is
> currently awash in calls to BUILD_BUG_ON_ZERO as it is.

Most of the time it will hidden as a macro-in-a-macro, like in
ARRAY_SIZE().  So the length of the name doesn't matter much.  But then,
the _name_ itself doesn't matter much because authors of public macros
are the primary user group, not John Driverhacker.
-- 
Stefan Richter
-=====-=-=== --== -==--
http://arcgraph.de/sr/
