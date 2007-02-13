Return-Path: <linux-kernel-owner+w=401wt.eu-S1750816AbXBMQdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750816AbXBMQdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbXBMQdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:33:43 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:38284 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbXBMQdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:33:43 -0500
Date: Tue, 13 Feb 2007 08:28:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: Coding style RFC: convert "for (i=0;i<ARRAY_SIZE(array);i++)"
 to "array_for_each(index, array)"
Message-Id: <20070213082845.84212ca0.randy.dunlap@oracle.com>
In-Reply-To: <20070213073738.GB23804@rhun.ibm.com>
References: <1171324070.1528.25.camel@localhost>
	<20070213073738.GB23804@rhun.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007 09:37:38 +0200 Muli Ben-Yehuda wrote:

> On Mon, Feb 12, 2007 at 03:47:50PM -0800, Joe Perches wrote:
> 
> > Now that most of the sizeof(array)/sizeof(array[0]) conversions have
> > been done (there are about 800 done and about another 130 left),
> > perhaps it could be useful to change the code to use a define
> > similar to the list_for_each
> > 
> > #define list_for_each(pos, head) \
> > 	for (pos = (head)->next; prefetch(pos->next), pos != (head); \
> >         	pos = pos->next)
> > 
> > perhaps
> > 
> > #define array_for_each(index, array) \
> > 	for ((index) = 0; (index) < ARRAY_SIZE((array)); (index)++)
> 
> Could we please stop "improving" the C language? it has served us fine
> so far.

I'm with Muli.  The open-coded for loop is fine (using ARRAY_SIZE).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
