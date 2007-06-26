Return-Path: <linux-kernel-owner+w=401wt.eu-S1760357AbXFZTRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357AbXFZTRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759318AbXFZTQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:16:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38071 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758104AbXFZTQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:16:51 -0400
Date: Tue, 26 Jun 2007 12:16:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@google.com>
cc: Ethan Solomita <solo@google.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
Subject: Re: [RFC 1/7] cpuset write dirty map
In-Reply-To: <468023CA.2090401@google.com>
Message-ID: <Pine.LNX.4.64.0706261216110.20282@schroedinger.engr.sgi.com>
References: <465FB6CF.4090801@google.com> <Pine.LNX.4.64.0706041138410.24412@schroedinger.engr.sgi.com>
 <46646A33.6090107@google.com> <Pine.LNX.4.64.0706041250440.25535@schroedinger.engr.sgi.com>
 <468023CA.2090401@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Ethan Solomita wrote:

> 	The effect of this patchset is straightforward. Without it there are
> long hangs between appearances of the date. With it the dates are all 5
> (or sometimes 6) seconds apart.
> 
> 	I also added printks to the kernel to verify that, without these
> patches, the tee was being throttled (along with lots of other things),
> and with the patch only pdflush is being throttled.

That sounds good. Andrew: Any chance that we can get this patchset merged?

