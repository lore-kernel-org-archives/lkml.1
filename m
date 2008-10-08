Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYJHToZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYJHToZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756663AbYJHTli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:41:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755826AbYJHTlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:41:37 -0400
Message-ID: <48ED0B68.2060001@linux-foundation.org>
Date: Wed, 08 Oct 2008 14:35:04 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/1] hugetlbfs: handle pages higher order than MAX_ORDER
References: <1223458431-12640-1-git-send-email-apw@shadowen.org> <1223458431-12640-2-git-send-email-apw@shadowen.org> <48ECDD37.8050506@linux-foundation.org> <20081008185532.GA13304@brain>
In-Reply-To: <20081008185532.GA13304@brain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:

> With SPARSEMEM turned on and VMEMMAP turned off a valid combination,
> we will end up scribbling all over memory which is pretty serious so for
> that reason we should handle this case.  There are cirtain combinations
> of features which require SPARSMEM but preclude VMEMMAP which trigger this.

Which configurations are we talking about? 64 bit configs may generally be
able to use VMEMMAP since they have lots of virtual address space.



