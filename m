Return-Path: <linux-kernel-owner+w=401wt.eu-S934602AbZGQNaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934602AbZGQNaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 09:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934449AbZGQNaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 09:30:14 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45475 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934443AbZGQNaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 09:30:13 -0400
Subject: Re: [PATCH] Clean up some extra unused arguments in fs/ubifs/
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: dedekind@infradead.org
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>, linux-mtd@lists.infradead.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247815718.11353.177.camel@localhost.localdomain>
References: <20090717062101.11440.49299.sendpatchset@subratamodak.linux.ibm.com>
	 <1247815718.11353.177.camel@localhost.localdomain>
Content-Type: text/plain
Organization: IBM
Date: Fri, 17 Jul 2009 18:59:49 +0530
Message-Id: <1247837392.5690.3.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-17 at 10:28 +0300, Artem Bityutskiy wrote:
> On Fri, 2009-07-17 at 11:51 +0530, Subrata Modak wrote:
> > Hi,
> > 
> > "const struct ubifs_info *c" exists as an extra argument for major
> > function definitions under the "fs/ubifs/*" code. The reason why
> > this extra argument exists is based on assumtion that there
> > will be several key schemes. It is possible to add more than one,
> > but we use only one. When there is practically no usage of them
> > presently, they can be removed, and if needed can be added later.
> > 
> > The following patch does that by removing:
> > 1) "const struct ubifs_info *c" where it is not used/necessary,
> > 2) remove xent_key_init_hash() function, as it is also not used,
> > 3) remove data_key_init_flash() function, as it is also not used anywhere,
> 
> Fine with 2 and 3. Not fine with 1, unless it makes the code smaller
> or more optimal.

Hmmm. I see. But, it took 95% of my effort. Ok then, do you want me to
send a separate patch for 2) & 3), or, you will automatically isolate
them from the sent one.

Regards--
Subrata

> 

