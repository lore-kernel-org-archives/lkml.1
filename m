Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZGPLWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZGPLWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 07:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZGPLWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 07:22:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38151 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbZGPLWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 07:22:09 -0400
Subject: Re: [PATCH 02/06] Fix compilation warning for fs/ubifs/commit.c
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: dedekind@infradead.org
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-mtd@lists.infradead.org,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247742765.11353.114.camel@localhost.localdomain>
References: <20090715021901.4112.45973.sendpatchset@subratamodak.linux.ibm.com>
	 <1247640750.11353.6.camel@localhost.localdomain>
	 <4A5E1D1A.3090705@s5r6.in-berlin.de>
	 <1247738232.11353.90.camel@localhost.localdomain>
	 <1247742274.5572.8.camel@subratamodak.linux.ibm.com>
	 <1247742765.11353.114.camel@localhost.localdomain>
Content-Type: text/plain
Organization: IBM
Date: Thu, 16 Jul 2009 16:51:49 +0530
Message-Id: <1247743313.5572.10.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 14:12 +0300, Artem Bityutskiy wrote:
> On Thu, 2009-07-16 at 16:34 +0530, Subrata Modak wrote:
> > Correct. There has been other warning fixes i have sent to LKML, where i
> > have tweaked the code to fix the compilation, but, code tweaking may not
> > be possible in this case. However , i would  still investigate.
> 
> I do not think that in _general_ it is a good idea to tweak code just
> to have gcc pleased, granted the code is correct. In this case it is
> more preferable to shut it up, e.g., using 'unitialized_var()'.

Great. I would write more description in the patch then. Thanks.

Regards--
Subrata

> 

