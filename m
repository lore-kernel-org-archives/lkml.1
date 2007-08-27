Return-Path: <linux-kernel-owner+w=401wt.eu-S1761636AbXH0TdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761636AbXH0TdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 15:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758469AbXH0Tcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:32:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35498 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758215AbXH0Tcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:32:51 -0400
Date: Mon, 27 Aug 2007 12:32:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, Keith Owens <kaos@ocs.com.au>
Subject: Re: [patch 13/28] Add cmpxchg_local, cmpxchg64 and cmpxchg64_local
 to ia64
In-Reply-To: <20070827155527.817330797@polymtl.ca>
Message-ID: <Pine.LNX.4.64.0708271231390.4667@schroedinger.engr.sgi.com>
References: <20070827155234.062715780@polymtl.ca> <20070827155527.817330797@polymtl.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007, Mathieu Desnoyers wrote:

> Add the primitives cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64. They
> use cmpxchg_acq as underlying macro, just like the already existing ia64
> cmpxchg().

Acked-by: Christoph Lameter <clameter@sgi.com>

Note cmpxchg is *not* a performance win vs interrupt disable / enable on IA64.

