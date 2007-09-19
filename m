Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbXISR34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbXISR34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbXISR3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:29:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35234 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751181AbXISR3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:29:41 -0400
Date: Wed, 19 Sep 2007 10:29:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Anton Altaparmakov <aia21@cam.ac.uk>
cc: David Rientjes <rientjes@google.com>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [03/17] is_vmalloc_addr(): Check if an address is within the
 vmalloc boundaries
In-Reply-To: <167F960F-0A93-4263-8AE6-1B0CEBB2C9D1@cam.ac.uk>
Message-ID: <Pine.LNX.4.64.0709191029230.11138@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <20070919033641.009931707@sgi.com>
 <alpine.DEB.0.9999.0709182329110.6251@chino.kir.corp.google.com>
 <E1A595D3-FD5B-44EA-A99D-BB581642F0E8@cam.ac.uk>
 <alpine.DEB.0.9999.0709190103560.12827@chino.kir.corp.google.com>
 <167F960F-0A93-4263-8AE6-1B0CEBB2C9D1@cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Anton Altaparmakov wrote:

> I suspect that is_vmalloc_addr() should not be in linux/mm.h at all and should
> be in linux/vmalloc.h instead and vmalloc.h should include linux/highmem.h.
> That would be more sensible than sticking a vmalloc related function into
> linux/mm.h where it does not belong...

Tried it and that leads to all sort of other failures.
