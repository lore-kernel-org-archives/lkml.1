Return-Path: <linux-kernel-owner+w=401wt.eu-S935652AbYEBSar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935652AbYEBSar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762533AbYEBSaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:30:39 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46414 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617AbYEBSaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:30:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <481B5DBF.7020604@s5r6.in-berlin.de>
Date: Fri, 02 May 2008 20:30:23 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: fw-ohci: blacklist dualbuffer for TSB43AB22A
 on ASUS boards
References: <tkrat.f5c7b5be9496fcdd@s5r6.in-berlin.de>
In-Reply-To: <tkrat.f5c7b5be9496fcdd@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> According to https://bugzilla.redhat.com/show_bug.cgi?id=435550 the
> TI TSB43AB22A on an ASUSTeK M2NPV-VM motherboard does not work in
> dual-buffer mode with dvgrab, but does so in packet-per-buffer mode.
...
> (subject to retesting by the reporter)

The reporter found that dual-buffer actually works if memory is reduced 
to 2GB.  So there is a DMA mapping/ IOMMU related problem between kernel 
and board somewhere.  Patch withdrawn.
-- 
Stefan Richter
-=====-==--- -=-= ---=-
http://arcgraph.de/sr/
