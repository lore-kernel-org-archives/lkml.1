Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbYC1CaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbYC1CaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbYC1C3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:29:55 -0400
Received: from relay2.sgi.com ([192.48.171.30]:32879 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754737AbYC1C3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:29:54 -0400
Date: Thu, 27 Mar 2008 19:27:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3 of 4] sparsemem: reduce i386 PAE section size
In-Reply-To: <47EC574C.10006@goop.org>
Message-ID: <Pine.LNX.4.64.0803271926520.11576@schroedinger.engr.sgi.com>
References: <b7d0773c79887ca98d6c.1206664119@localhost>
 <Pine.LNX.4.64.0803271734450.10635@schroedinger.engr.sgi.com>
 <47EC574C.10006@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008, Jeremy Fitzhardinge wrote:

> Christoph Lameter wrote:
> > 
> > There are patches in mm which changes that situation. You should have 5 or 6
> > more flags to play with.
> >   
> 
> Oh, good.  We can play with it some more when everything gets merged together.

Only works on i386 if you either use sparsemem / vmemmap or not sparsemem 
though. Is there any need for the other sparsemem memory models? Or could 
we disable them like on x86_64?

