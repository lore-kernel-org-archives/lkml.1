Return-Path: <linux-kernel-owner+w=401wt.eu-S965663AbXCLLl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965663AbXCLLl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965698AbXCLLl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:41:29 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:60141 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965663AbXCLLl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:41:28 -0400
Message-ID: <45F53C4D.30802@s5r6.in-berlin.de>
Date: Mon, 12 Mar 2007 12:41:01 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@muc.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BUILD_BUG_ON_ZERO -> BUILD_BUG_OR_ZERO
References: <1173655694.32234.213.camel@localhost.localdomain>	 <45F51C25.76E4.0078.0@novell.com> <1173691510.32234.222.camel@localhost.localdomain>
In-Reply-To: <1173691510.32234.222.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Mon, 2007-03-12 at 08:23 +0000, Jan Beulich wrote:
>> I have to admit that I don't see the point here - I can't seem to make
>> any sense of the OR... Jan
> 
> At least one other person thought that:
> 
> 	#define BUILD_BUG_ON_ZERO(e) BUILD_BUG_ON((e) == 0)
> 
> OTOH, BUILD_BUG_OR_ZERO says what happens: either it's a build bug, or
> it's zero.

What about ZERO_UNLESS_BUILD_BUG_ON(e)? It's long though...
-- 
Stefan Richter
-=====-=-=== --== -==--
http://arcgraph.de/sr/
