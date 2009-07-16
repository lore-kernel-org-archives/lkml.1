Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbZGPNLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbZGPNLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 09:11:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbZGPNLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 09:11:00 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51894 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbZGPNLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 09:11:00 -0400
Subject: Re: [PATCH 02/06] Fix compilation warning for fs/ubifs/commit.c
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: dedekind@infradead.org
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>, linux-mtd@lists.infradead.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247748885.11353.156.camel@localhost.localdomain>
References: <20090716124133.25463.33849.sendpatchset@subratamodak.linux.ibm.com>
	 <1247748885.11353.156.camel@localhost.localdomain>
Content-Type: text/plain
Organization: IBM
Date: Thu, 16 Jul 2009 18:40:18 +0530
Message-Id: <1247749820.5572.14.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 15:54 +0300, Artem Bityutskiy wrote:
> On Thu, 2009-07-16 at 18:11 +0530, Subrata Modak wrote:
> > does not use:
> > 	"const struct ubifs_info *c"
> > inside the inline function. I do not see any practical usage of
> > "const struct ubifs_info *c" in the functions key_read() and key_write().
> > Is there something which i am missing to understand ?
> > 
> > When i applied the following patch, still the "fs/ubifs/" code compiled fine.
> > If the below fix is correct, i can try fixing some other functions i saw
> > having similar defects.
> 
> Yeah, I think the reason why we have this extra argument there is that
> we assumed there will be several key schemes. It is possible to add more
> than one, but we use only one.
> 
> Since you have already spent your time for this, could you please check
> if removing this 'c' makes the code smaller? If not, I'd prefer not to

Ok. I would let you know soon.

Regards--
Subrata

> remove it.
> 

