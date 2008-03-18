Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYCSWFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYCSWFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933611AbYCSUbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:31:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57538 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933606AbYCSUbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:31:53 -0400
Date: Tue, 18 Mar 2008 17:49:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, pj@sgi.com,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [5/18] Expand the hugetlbfs sysctls to handle arrays for all hstates
Message-ID: <20080318164903.GG11966@one.firstfloor.org>
References: <20080317258.659191058@firstfloor.org> <20080317015818.E30041B41E0@basil.firstfloor.org> <20080318143438.GE23866@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318143438.GE23866@csn.ul.ie>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, offhand it's not super-clear why max_huge_pages is not part of
> hstate as we only expect one hstate per pagesize anyway.

They need to be an separate array for the sysctl parsing function.

-Andi

