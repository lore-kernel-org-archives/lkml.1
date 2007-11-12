Return-Path: <linux-kernel-owner+w=401wt.eu-S1759771AbXKMALu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759771AbXKMALu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 19:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXKMALl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 19:11:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:33479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbXKMALl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 19:11:41 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: x86_64: Make sparsemem/vmemmap the default memory model
Date: Tue, 13 Nov 2007 00:59:34 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>, Andy Whitcroft <apw@shadowen.org>
References: <Pine.LNX.4.64.0711121549370.29178@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711121549370.29178@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711130059.34346.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007 00:52:14 Christoph Lameter wrote:
> Use sparsemem as the only memory model for UP, SMP and NUMA.
> 
> Measurements indicate that DISCONTIGMEM has a higher
> overhead than sparsemem. And FLATMEMs benefits are minimal. So I think its
> best to simply standardize on sparsemem.

How about the memory overhead? Is it the same too?
And code size vs flatmem?

-Andi
