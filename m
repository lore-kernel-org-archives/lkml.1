Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbXISR3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbXISR3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbXISR3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:29:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35153 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752883AbXISR3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:29:06 -0400
Date: Wed, 19 Sep 2007 10:29:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Anton Altaparmakov <aia21@cam.ac.uk>
cc: David Rientjes <rientjes@google.com>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [03/17] is_vmalloc_addr(): Check if an address is within the
 vmalloc boundaries
In-Reply-To: <E1A595D3-FD5B-44EA-A99D-BB581642F0E8@cam.ac.uk>
Message-ID: <Pine.LNX.4.64.0709191028211.11138@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <20070919033641.009931707@sgi.com>
 <alpine.DEB.0.9999.0709182329110.6251@chino.kir.corp.google.com>
 <E1A595D3-FD5B-44EA-A99D-BB581642F0E8@cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Anton Altaparmakov wrote:

> There even is such a function already in mm/sparse.c::vaddr_in_vmalloc_area()
> with pretty identical content.  I would suggest either this new inline should
> go away completely and use the existing one and export it or the existing one
> should go away and the inline should be used.  It seems silly to have two
> functions with different names doing exactly the same thing!

Just in case you have not noticed: This patchset removes the 
vaddr_in_vmalloc_area() in sparse.c

