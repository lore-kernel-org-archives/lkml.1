Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbXFKR7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbXFKR7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 13:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbXFKR67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 13:58:59 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35660 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbXFKR66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 13:58:58 -0400
Message-ID: <466D8D4B.8050100@zytor.com>
Date: Mon, 11 Jun 2007 10:58:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move the kernel to 16MB for NUMA-Q
References: <466D550C.4030600@shadowen.org> <63a08cc7547f14065becdf9a94d0d529@pinky> <20070611091558.f468f205.akpm@linux-foundation.org> <20070611172006.GI9174@redhat.com> <466D8B0F.3080608@gmail.com>
In-Reply-To: <466D8B0F.3080608@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> 
> Aligning the kernel image on 4M could gain an additional TLB entry if
> the kernel image would fit in one (4M aligned) hugepage, but not in the
> 3M that's left after loading the kernel at 1M physical. And that stuff
> about the MTRRs...
> 

Yup.  Most CPUs won't actually use a largepage for the kernel if it's
below 4 MB (2 MB with PAE, so that's what x86-64 uses.)

	-hpa
