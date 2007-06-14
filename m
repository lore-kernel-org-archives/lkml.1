Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbXFNVhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbXFNVhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbXFNVhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:37:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57688 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750695AbXFNVhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:37:33 -0400
Date: Thu, 14 Jun 2007 14:37:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
 Blocksize support
In-Reply-To: <20070614143248.736312f8.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706141436030.1797@schroedinger.engr.sgi.com>
References: <20070614193839.878721298@sgi.com> <20070614130645.cabdff1b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com>
 <20070614143248.736312f8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007, Andrew Morton wrote:

> We want the 100% case.

Yes that is what we intend to do. Universal support for larger blocksize. 
I.e. your desktop filesystem will use 64k page size and server platforms 
likely much larger. fsck times etc etc are becoming an issue for desktop 
systems given the capacities and lockinhg becomes an issue the more 
multicore your desktops become.

