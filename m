Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbXFKTEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbXFKTEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbXFKTDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:03:55 -0400
Received: from terminus.zytor.com ([192.83.249.54]:59700 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbXFKTDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:03:54 -0400
Message-ID: <466D9C00.6030608@zytor.com>
Date: Mon, 11 Jun 2007 12:01:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move the kernel to 16MB for NUMA-Q
References: <466D550C.4030600@shadowen.org> <63a08cc7547f14065becdf9a94d0d529@pinky> <20070611091558.f468f205.akpm@linux-foundation.org> <20070611172006.GI9174@redhat.com> <466D882D.70001@zytor.com> <Pine.LNX.4.64.0706112019310.19578@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706112019310.19578@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jun 11 2007 10:36, H. Peter Anvin wrote:
>> Picking the 16 MB base is a bit obnoxious on small-memory machines, 4 MB
>> would probably be a more reasonable base.  Of course, 16 MB would avoid
>>  the issue of the handful of machines with memory holes at 15-16 MB.
> 
> How will this work at all with a 5 MB machine?

Does current kernels work at all on a 5 MB machine?

(I used Linux on a 5 MB machine many years ago, but modern kernels are a
different issue...)

	-hpa

