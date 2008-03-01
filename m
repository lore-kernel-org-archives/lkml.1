Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYCAEGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYCAEGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 23:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbYCAEGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 23:06:24 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34375 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751363AbYCAEGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 23:06:23 -0500
Message-Id: <20080301040534.797979115@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Feb 2008 20:05:34 -0800
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@shadowen.org
Cc: linux-mm@kback.org
Subject: [rfc 00/10] [RFC] Page flags: Saving some, making handling easier etc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A set of patches that attempts to improve page flag handling. First of all a
method is introduces to generate the page flag functions using macros. Then
the number of page flags used by sparsemem is reduced.

Then we add a way to export enum constant to the preprocessor which allows
us to get rid of __ZONE_COUNT and use the NR_PAGEFLAGS for the calculation
of actually available page flags for fields.

Lastly there is a land grab of page flags for various ongoing VM projects.

-- 
