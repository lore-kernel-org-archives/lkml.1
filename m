Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbXEXVto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbXEXVto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbXEXVth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:49:37 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:32446 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbXEXVtg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:49:36 -0400
Date: Thu, 24 May 2007 14:55:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
Message-Id: <20070524145517.1f32cd94.randy.dunlap@oracle.com>
In-Reply-To: <20070524142908.f39f42ea.akpm@linux-foundation.org>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<46540DB2.5000605@googlemail.com>
	<Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
	<4654AC94.6080601@googlemail.com>
	<20070523150122.f9946f37.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com>
	<20070523153730.e0e9e91d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>
	<20070523182145.7d7f1f7e.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
	<20070524073131.GA17501@elte.hu>
	<Pine.LNX.4.64.0705241418270.31613@schroedinger.engr.sgi.com>
	<20070524142908.f39f42ea.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 14:29:08 -0700 Andrew Morton wrote:

> On Thu, 24 May 2007 14:20:03 -0700 (PDT)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> >   Bytes b4 0xffff81000208f6b0:  55 db fe ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a UUpÿ....ZZZZZZZZ
> >     Object 0xffff81000208f6c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >     Object 0xffff81000208f6d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >     Object 0xffff81000208f6e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >     Object 0xffff81000208f6f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >     Object 0xffff81000208f700:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >     Object 0xffff81000208f710:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >     Object 0xffff81000208f720:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >     Object 0xffff81000208f730:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >    Redzone 0xffff81000208f8c0:  ab bb bb bb bb bb bb bb                         «»»»»»»»
> 
> can we do this with lib/hexdump.c rather than having a private implementation
> in slub?

This is pretty-printing.  and creature-feep.
But lib/hexdump.c can probably do this if we add a "prefix/tag" string
parameter to it.

Hugh D. wants it to print 32-bit quantities, not just bytes.
Yet another parameter.

I'll look into these unless Christoph et al does so first.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
