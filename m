Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbYGKUtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbYGKUtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYGKUtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:49:41 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:35171 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbYGKUtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:49:41 -0400
X-BigFish: VPS-15(zz1432R98dR7efV1805Mzz10d3izzz32i6bh87il43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3V0HY-03-FEO-01
Date: Fri, 11 Jul 2008 14:52:53 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: David Brigada <brigad@rpi.edu>
CC: jim.cromie@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       linux-geode@lists.infradead.org
Subject: Re: PCI-ISA Bridge not operating
Message-ID: <20080711205253.GA30670@cosmic.amd.com>
References: <487774F9.6000001@rpi.edu> <20080711164845.GB28720@cosmic.amd.com> <4877908C.4060706@rpi.edu> <4877AD63.3000405@rpi.edu> <20080711191045.GB29570@cosmic.amd.com> <4877BF32.9040304@rpi.edu> <20080711202906.GF29570@cosmic.amd.com> <4877C325.7070903@rpi.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4877C325.7070903@rpi.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 11 Jul 2008 20:49:19.0005 (UTC) FILETIME=[96D334D0:01C8E397]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/08 16:31 -0400, David Brigada wrote:

<snip>
> >> That *is* puzzling.  When I do lspci, the entry for the IT8888G does not 
> >> appear.  I don't have much experience with PCI internals.  Would that be 
> >> because there is no driver for it in the kernel, or is there something 
> >> more insidious afoot?
> > 
> > Well - the first step would be to get a dmesg output.  if the kernel
> > is doing anything to the device at all, the dmesg will show it.
> 
> The dmesg output doesn't have anything related to the device.  I have 
> attached my dmesg output for completeness.  Ignore the last four lines, 
> that's my testing.  The PCI ID of the IT8888G is 1283:8888.

Okay - interesting.  Can you try lcpci with direct hardware access?
By default lspci only lists those devices that Linux found and
enumerated.  Direct hardware access does the CF8/CFC dance.  If 
we find it that way, then its a hunt to figure out why Linux silently
discarded it.  Also, check the I/O ports you are trying to access in
/proc/ioports to see if anybody has claimed them.

Jordan

