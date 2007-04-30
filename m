Return-Path: <linux-kernel-owner+w=401wt.eu-S1161639AbXD3FX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161639AbXD3FX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 01:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161640AbXD3FX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 01:23:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47388 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161639AbXD3FX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 01:23:26 -0400
Date: Sun, 29 Apr 2007 22:23:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <200704281939.28868.maximlevitsky@gmail.com>
Message-ID: <Pine.LNX.4.64.0704292221480.1978@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <200704281939.28868.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Maxim Levitsky wrote:

> 1) Is it possible for block device to assume that it will alway get big 
> requests (and aligned by big blocksize) ?

That is one of the key problems. We hope that Mel Gorman's antifrag work 
will get us there.
 
> 2) Does metadata reading/writing occuress also using same big blocksize ?

It can if the filesystem decides to and sets up the order the mapping.
 
> 3 If so, How __bread/__getblk are affrected? Does returned buffer_head point 
> to whole block ?

Correct.

