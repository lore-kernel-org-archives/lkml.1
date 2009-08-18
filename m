Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbZHROTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbZHROTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZHROTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:19:02 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:38035 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752233AbZHROTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:19:01 -0400
Date: Tue, 18 Aug 2009 10:18:48 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] page-allocator: Move pcp static fields for high and
 batch off-pcp and onto the zone
In-Reply-To: <1250594162-17322-4-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0908181015420.32284@gentwo.org>
References: <1250594162-17322-1-git-send-email-mel@csn.ul.ie> <1250594162-17322-4-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This will increase the cache footprint for the hot code path. Could these
new variable be moved next to zone fields that are already in use there?
The pageset array is used f.e.


