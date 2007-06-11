Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbXFKUvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbXFKUvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbXFKUva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:51:30 -0400
Received: from terminus.zytor.com ([192.83.249.54]:39484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbXFKUv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:51:29 -0400
Message-ID: <466DB5B8.80005@zytor.com>
Date: Mon, 11 Jun 2007 13:51:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move the kernel to 16MB for NUMA-Q
References: <466D550C.4030600@shadowen.org> <63a08cc7547f14065becdf9a94d0d529@pinky> <20070611091558.f468f205.akpm@linux-foundation.org> <20070611172006.GI9174@redhat.com> <466D882D.70001@zytor.com> <Pine.LNX.4.64.0706112019310.19578@fbirervta.pbzchgretzou.qr> <466D9C00.6030608@zytor.com> <Pine.LNX.4.64.0706112239080.19578@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706112239080.19578@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> (yay, 3.09 bogomips and a totally incapable processor :p)
> Have not tried more recent kernels yet though.

Too bad I don't still have access to the 0.59 bogomips "double sigma"
386 machine that had the dubious honor of being the slowest Linux
machine in the world for quite a while.  That machine had 3 MB of RAM.

However, to tie it back to the original discussion, these
extremely-low-memory machines need nonstandard kernel options anyay.

While doing my SuperRescue disk I was able to get it down to the point
where I could successfully boot and use the system on a 24 MB machine; I
personally run a 32 MB box as a server today.

	-hpa
