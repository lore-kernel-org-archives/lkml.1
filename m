Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbXFKSqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbXFKSqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbXFKSqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:46:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbXFKSqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:46:39 -0400
Date: Mon, 11 Jun 2007 14:46:21 -0400
From: Dave Jones <davej@redhat.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move the kernel to 16MB for NUMA-Q
Message-ID: <20070611184621.GA25371@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@shadowen.org>, Steve Fox <drfickle@us.ibm.com>,
	Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
References: <466D550C.4030600@shadowen.org> <63a08cc7547f14065becdf9a94d0d529@pinky> <20070611091558.f468f205.akpm@linux-foundation.org> <20070611172006.GI9174@redhat.com> <466D882D.70001@zytor.com> <Pine.LNX.4.64.0706112019310.19578@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706112019310.19578@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 08:19:57PM +0200, Jan Engelhardt wrote:
 > 
 > On Jun 11 2007 10:36, H. Peter Anvin wrote:
 > >
 > >Picking the 16 MB base is a bit obnoxious on small-memory machines, 4 MB
 > >would probably be a more reasonable base.  Of course, 16 MB would avoid
 > >  the issue of the handful of machines with memory holes at 15-16 MB.
 > 
 > How will this work at all with a 5 MB machine?

Unless you're running with a bunch of CONFIG_EMBEDDED options enabled,
and a seriously pared down (almost to the point of uselessness)
userspace, you may have already lost.

Do such beasts even exist ?  My memories of low-memory x86en I had
only allowed power of 2 memory sizes.

	Dave

-- 
http://www.codemonkey.org.uk
