Return-Path: <linux-kernel-owner+w=401wt.eu-S1767180AbXDESTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767180AbXDESTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 14:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767192AbXDESTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 14:19:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43412 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767180AbXDESTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 14:19:03 -0400
Date: Thu, 5 Apr 2007 11:19:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4 (SLUB)
In-Reply-To: <1175786199.13125.3.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0704051118250.9800@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> 
 <1175637332.6185.4.camel@dyn9047017100.beaverton.ibm.com> 
 <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com> 
 <1175643507.6185.12.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031638570.12109@schroedinger.engr.sgi.com> 
 <1175644314.6185.18.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031653060.12109@schroedinger.engr.sgi.com> 
 <1175698437.6185.21.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704040946370.24640@schroedinger.engr.sgi.com> 
 <1175709755.6185.34.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704041103060.26866@schroedinger.engr.sgi.com> 
 <Pine.LNX.4.64.0704041120250.793@schroedinger.engr.sgi.com> 
 <1175727185.5019.8.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704041556530.11769@schroedinger.engr.sgi.com> 
 <1175730157.5019.19.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704041730470.22161@schroedinger.engr.sgi.com> 
 <1175741046.13125.0.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704042127230.14168@schroedinger.engr.sgi.com>
 <1175786199.13125.3.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007, Badari Pulavarty wrote:

> On Wed, 2007-04-04 at 21:29 -0700, Christoph Lameter wrote:
> > Here is a patch that adds validation (only for cpuslabs and partial 
> > slabs but thats where the action is). Apply this patch
> > and then do
> > 
> > echo 1 >/sys/slab/<cache-to-check>/validate
> > 
> > I suggest to boot with full debugging and then run this on the ACPI slabs.
> 
> Did this and didn't trigger any problems.

Duh. Must have been in the full slabs. Maybe I should add a tracking of 
full slabs for the debug case. Would also enable leak detection.
