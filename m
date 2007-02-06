Return-Path: <linux-kernel-owner+w=401wt.eu-S1751886AbXBFJe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbXBFJe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbXBFJe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:34:29 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:8051
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886AbXBFJe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:34:29 -0500
Message-Id: <45C859FB.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Tue, 06 Feb 2007 09:35:39 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "linux1394-devel" <linux1394-devel@lists.sourceforge.net>,
       "David Moore" <dcm@mit.edu>,
       "linux-kernel" <linux-kernel@vger.kernel.org>, <discuss@x86-64.org>
Subject: Re: [PATCH] Missing critical phys_to_virt in lib/swiotlb.c
References: <1170614380.26464.52.camel@PISCES.MIT.EDU>
 <20070205133556.9b290d0a.akpm@linux-foundation.org>
 <200702060856.45473.ak@suse.de>
In-Reply-To: <200702060856.45473.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Shouldn't be applied without further analysis.

I don't think further analysis is required before this change be done, the missing
conversion is rather obvious when comparing to all other functions in that file.

Whether the observed crashes really origin from the missing bits here is a
different question.

Jan
