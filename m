Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbXDMQ5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbXDMQ5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 12:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbXDMQ5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 12:57:41 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42311 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbXDMQ5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 12:57:41 -0400
Date: Fri, 13 Apr 2007 09:57:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Badari Pulavarty <pbadari@gmail.com>, Christoph Lameter <clameter@sgi.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cache_k8_northbridges() overflows beyond allocation
 (Was: 2.6.21-rc5-mm4 (SLUB))
Message-Id: <20070413095735.c50bc142.akpm@linux-foundation.org>
In-Reply-To: <200704131745.37795.ak@suse.de>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704041103060.26866@schroedinger.engr.sgi.com>
	<1176477222.8559.4.camel@dyn9047017100.beaverton.ibm.com>
	<200704131745.37795.ak@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 17:45:37 +0200 Andi Kleen <ak@suse.de> wrote:

> 
> > 
> > cache_k8_northbridges() is storing config values to incorrect locations
> > (in flush_words) and also its overflowing beyond the allocation, causing
> > slab verification failures.
> 
> Oops. Thanks for tracking that down, Badari.
> 
> Andrew, clear .21 candidate.

OK.  And for 2.6.20.x, methinks.
