Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbYIEBxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbYIEBxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 21:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbYIEBxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 21:53:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54408 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbYIEBxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 21:53:00 -0400
Date: Fri, 05 Sep 2008 10:52:10 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 2/4] pull out zone cpuset and watermark checks for reuse
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <1220467452-15794-3-git-send-email-apw@shadowen.org>
References: <1220467452-15794-1-git-send-email-apw@shadowen.org> <1220467452-15794-3-git-send-email-apw@shadowen.org>
Message-Id: <20080905105110.5A41.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When allocating we need to confirm that the zone we are about to allocate
> from is acceptable to the CPUSET we are in, and that it does not violate
> the zone watermarks.  Pull these checks out so we can reuse them in a
> later patch.
> 
> Signed-off-by: Andy Whitcroft <apw@shadowen.org>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


