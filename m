Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbZFHOc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbZFHOc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbZFHOcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:32:21 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:44986 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754823AbZFHOcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:32:20 -0400
Date: Mon, 8 Jun 2009 10:32:12 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Do not unconditionally treat zones that fail
 zone_reclaim() as full
In-Reply-To: <1244466090-10711-4-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0906081030280.21954@gentwo.org>
References: <1244466090-10711-1-git-send-email-mel@csn.ul.ie> <1244466090-10711-4-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok this patch addresses a bug in zone reclaim introduced by Paul Jackson
in commit 9276b1bc96a132f4068fdee00983c532f43d3a26. Before that commit
zone reclaim would not mark a zone as full if it failed but simply
continue scanning.

Acked-by: Christoph Lameter <cl@linux-foundation.org>

