Return-Path: <linux-kernel-owner+w=401wt.eu-S1751393AbZHRTFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbZHRTFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 15:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbZHRTFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 15:05:32 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:53210 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751169AbZHRTFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 15:05:31 -0400
Date: Tue, 18 Aug 2009 15:05:25 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] Reduce searching in the page allocator
 fast-path
In-Reply-To: <20090818165340.GB13435@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0908181357100.3840@gentwo.org>
References: <1250594162-17322-1-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0908181019130.32284@gentwo.org> <20090818165340.GB13435@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009, Mel Gorman wrote:

> Can you point me to which patchset you are talking about specifically that
> uses per-cpu atomics in the hot path? There are a lot of per-cpu patches
> related to you that have been posted in the last few months and I'm not sure
> what any of their merge status' is.

The following patch just moved the page allocator to use the new per cpu
allocator. It does not use per cpu atomic yet but its possible then.

http://marc.info/?l=linux-mm&m=124527414206546&w=2
