Return-Path: <linux-kernel-owner+w=401wt.eu-S1751849AbZHSLsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbZHSLsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 07:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZHSLsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 07:48:17 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:38418 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751494AbZHSLsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 07:48:17 -0400
Date: Wed, 19 Aug 2009 07:48:12 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] Reduce searching in the page allocator
 fast-path
In-Reply-To: <20090819090843.GB24809@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0908190747190.5621@gentwo.org>
References: <1250594162-17322-1-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0908181019130.32284@gentwo.org> <20090818165340.GB13435@csn.ul.ie> <alpine.DEB.1.10.0908181357100.3840@gentwo.org> <20090819090843.GB24809@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009, Mel Gorman wrote:

> Ok, I don't see this particular patch merged, is it in a merge queue somewhere?

The patch depends on Tejun's work to be merged that makes the per cpu
allocator available on all platforms. I believe that is in the queue for
2.6.32.

> After glancing through, I can see how it might help.  I'm going to drop patch
> 3 of this set that shuffles data from the PCP to the zone and take a closer
> look at those patches. Patch 1 and 2 of this set should still go ahead. Do
> you agree?

Yes.

