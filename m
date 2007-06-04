Return-Path: <linux-kernel-owner+w=401wt.eu-S1761534AbXFDTPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761534AbXFDTPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761622AbXFDTOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:14:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35971 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761948AbXFDTOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:14:42 -0400
Date: Mon, 4 Jun 2007 12:14:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <84144f020706041213x1d241794u98e9b3ca29865033@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706041213540.24935@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com> 
 <alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0706041200140.24550@schroedinger.engr.sgi.com>
 <84144f020706041213x1d241794u98e9b3ca29865033@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Pekka Enberg wrote:

> I thought the whole point of this patch was to get rid of the WARN_ON
> as you will get a nice oops if you dereference the pointer?

That is another patchset. See 
http://marc.info/?l=linux-kernel&w=2&r=1&s=DEVELKERNEL&q=b
 
