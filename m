Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYE3Q5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYE3Q5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 12:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYE3Q5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 12:57:43 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4970 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYE3Q5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 12:57:42 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, agl@us.ibm.com,
       wli@holomorphy.com, kenchen@google.com, dwg@au1.ibm.com,
       andi@firstfloor.org, Mel Gorman <mel@csn.ul.ie>, dean@arctic.org,
       abh@cray.com, Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 0/2] hugetlb reservations v4/MAP_NORESERVE V3 cleanups
References: <20080528184246.4753a78b.akpm@linux-foundation.org>
InReply-To: <20080528184246.4753a78b.akpm@linux-foundation.org>
Message-ID: <exportbomb.1212166524@pinky>
Date: Fri, 30 May 2008 17:57:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following on from Andrew's feedback here are a couple of update patches
for hugetlb reservations v4 and MAP_NORESERVE V3.  These introduce a number
of new helpers and use those throughout.

This stack consists of two patches to allow them to be merged into the
appropriate stacks.

huge-page-private-reservation-review-cleanups -- adds the helpers and
  utilises them in the base reservations stack, and

huge-page-MAP_NORESERVE-review-cleanups -- uses the same helpers in the
  MAP_NORESERVE stack.

-apw
