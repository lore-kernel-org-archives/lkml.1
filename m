Return-Path: <linux-kernel-owner+w=401wt.eu-S1761455AbXEPGNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455AbXEPGNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 02:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757058AbXEPGNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 02:13:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35548 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756771AbXEPGNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 02:13:23 -0400
Date: Tue, 15 May 2007 23:13:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Nate Diller <nate.diller@gmail.com>
Subject: Re: Pagecache zeroing: zero_user_segment, zero_user_segments and
 zero_user
In-Reply-To: <464A9BD1.1030300@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0705152309180.5772@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705151958210.4852@schroedinger.engr.sgi.com>
 <20070515202442.eeaa49a0.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705152100010.5091@schroedinger.engr.sgi.com>
 <464A8DF5.2010903@yahoo.com.au> <20070515222912.ae836e00.akpm@linux-foundation.org>
 <464A9BD1.1030300@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, Nick Piggin wrote:

> Well sure, if that's all Christoph is worried about, then it isn't
> really valid because in generic code we have to follow the architecture
> abstraction API -- there is no "non highmem platform" in generic code :)

But there is a default KM_USER0 that is used in many functions.

F.e.

filemap_copy_from_user *_iovec xip_truncate_page clear_user_highpage 
clear_highpage copy_user_highpage copy_highpage

So explicitly mentioning KM_USER0 in every function call is not a 
requirement.

