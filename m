Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbYFWQEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbYFWQEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 12:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbYFWQED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 12:04:03 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40420 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759869AbYFWQEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:04:00 -0400
Message-ID: <485FC974.70403@linux.vnet.ibm.com>
Date: Mon, 23 Jun 2008 11:04:04 -0500
From: Jon Tollefson <kniht@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Nishanth Aravamudan <nacc@us.ibm.com>,
       Adam Litke <agl@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC] hugetlb reservations -- MAP_PRIVATE fixes for split vmas
References: <485A8903.9030808@linux.vnet.ibm.com> <1213989474-5586-1-git-send-email-apw@shadowen.org>
In-Reply-To: <1213989474-5586-1-git-send-email-apw@shadowen.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> As reported by Adam Litke and Jon Tollefson one of the libhugetlbfs
> regression tests triggers a negative overall reservation count.  When
> this occurs where there is no dynamic pool enabled tests will fail.
>
> Following this email are two patches to fix this issue:
>
> hugetlb reservations: move region tracking earlier -- simply moves the
>   region tracking code earlier so we do not have to supply prototypes, and
>
> hugetlb reservations: fix hugetlb MAP_PRIVATE reservations across vma
>   splits -- which moves us to tracking the consumed reservation so that
>   we can correctly calculate the remaining reservations at vma close time.
>
> This stack is against the top of v2.6.25-rc6-mm3, should this solution
> prove acceptable it would probabally need porting below Nicks multiple
> hugepage size patches and those updated; if so I would be happy to do
> that too.
>
> Jon could you have a test on this and see if it works out for you.
>
> -apw
>   
Looking good so far.
I am not seeing any of the tests push the reservation number negative -
with this patch set applied

Jon


