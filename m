Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZGPL6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZGPL6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 07:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZGPL6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 07:58:18 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39988 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbZGPL6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 07:58:18 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A5F15B0.9030100@s5r6.in-berlin.de>
Date: Thu, 16 Jul 2009 13:57:36 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090630 SeaMonkey/1.1.17
MIME-Version: 1.0
To: dedekind@infradead.org
CC: Subrata Modak <subrata@linux.vnet.ibm.com>, linux-mtd@lists.infradead.org,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/06] Fix compilation warning for fs/ubifs/commit.c
References: <20090715021901.4112.45973.sendpatchset@subratamodak.linux.ibm.com>	 <1247640750.11353.6.camel@localhost.localdomain>	 <4A5E1D1A.3090705@s5r6.in-berlin.de> <1247738232.11353.90.camel@localhost.localdomain> <4A5F0F03.5080507@s5r6.in-berlin.de>
In-Reply-To: <4A5F0F03.5080507@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> So, is uninitialized_var() a good fix here?  I'd say it's not a 
> particular good one.  Count the lines of code of dbg_check_old_index() 
> and the maximum indentation level of it.  Then remember the teachings of 
> CodingStyle. :-)  See?  dbg_check_old_index() clearly isn't a prime 
> example of best kernel coding practice.  /Perhaps/ a little bit of 
> refactoring would make it easier to read, and as a bonus side effect, 
> make it unnecessary to use the slightly dangerous and 
> uninitialized_var() macro here.

PS:
On the other hand, it is debug code.  Is it bound to stay in there 
forever?  If not, then it's surely not worth the developer time to 
beautify it.
-- 
Stefan Richter
-=====-==--= -=== =----
http://arcgraph.de/sr/
