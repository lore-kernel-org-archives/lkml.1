Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbYIVQss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbYIVQss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYIVQsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:48:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38816 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYIVQsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:48:39 -0400
Subject: Re: [PATCH 1/2] Report the pagesize backing a VMA in
	/proc/pid/smaps
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
In-Reply-To: <20080922162152.GB7716@csn.ul.ie>
References: <1222047492-27622-1-git-send-email-mel@csn.ul.ie>
	 <1222047492-27622-2-git-send-email-mel@csn.ul.ie>
	 <1222098955.8533.50.camel@nimitz>  <20080922162152.GB7716@csn.ul.ie>
Content-Type: text/plain
Date: Mon, 22 Sep 2008 09:48:18 -0700
Message-Id: <1222102098.8533.62.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-22 at 17:21 +0100, Mel Gorman wrote:
> The corollary is that someone running with a 64K base page kernel may be
> surprised that the pagesize is always 4K. However I'll check if there is
> a simple way of checking out if the MMU size differs from PAGE_SIZE.

Sure.  If it isn't easy, the best thing to do is probably just to
document the "interesting" behavior.

-- Dave

