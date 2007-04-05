Return-Path: <linux-kernel-owner+w=401wt.eu-S1161071AbXDEDPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161071AbXDEDPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 23:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161094AbXDEDPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 23:15:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46539 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161071AbXDEDPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 23:15:09 -0400
Date: Wed, 4 Apr 2007 20:15:08 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4 (SLUB)
In-Reply-To: <1175741046.13125.0.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0704042013550.7664@schroedinger.engr.sgi.com>
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
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Badari Pulavarty wrote:

> > Were the slabs merged? Look at /sys/slab and see if there are any symlinks 
> > there.
> > 

Ok. symlinks there. Its a sporadic thing. I think I am going to add a slab
validator to SLUB that goes through all slabs and checks all objects for 
validity. Then we can trigger a scan through the acpi caches which should 
locate the problem.

