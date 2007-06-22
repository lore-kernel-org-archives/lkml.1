Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbXFVBqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbXFVBqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 21:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbXFVBqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 21:46:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33901 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751291AbXFVBqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 21:46:15 -0400
Date: Thu, 21 Jun 2007 18:46:14 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: NUMA BOF @OLS
In-Reply-To: <200706220112.51813.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.0706211844420.11754@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706211316150.9220@schroedinger.engr.sgi.com>
 <200706220112.51813.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Arnd Bergmann wrote:

> - Interface for preallocating hugetlbfs pages per node instead of system wide

We may want to get a bit higher level than that. General way of 
controlling subsystem use on nodes. One wants to restrict the slab 
allocator and the kernel etc on nodes too.

How will this interact with the other NUMA policy specifications?
 
> - architecture independent in-kernel API for enumerating CPU sockets with
>   multicore processors (not sure if that's the same as your existing subject).

Not sure what you mean by this. We already have a topology interface and 
the scheduler knows about these things.

