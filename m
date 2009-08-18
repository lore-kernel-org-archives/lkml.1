Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbZHROWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbZHROWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZHROWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:22:08 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:40653 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751476AbZHROWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:22:07 -0400
Date: Tue, 18 Aug 2009 10:22:01 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] Reduce searching in the page allocator
 fast-path
In-Reply-To: <1250594162-17322-1-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0908181019130.32284@gentwo.org>
References: <1250594162-17322-1-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This could be combined with the per cpu ops patch that makes the page
allocator use alloc_percpu for its per cpu data needs. That in turn would
allow the use of per cpu atomics in the hot paths, maybe we can
get to a point where we can drop the irq disable there.



