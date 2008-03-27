Return-Path: <linux-kernel-owner+w=401wt.eu-S1756936AbYC0ANU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbYC0ANU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 20:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYC0ANN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 20:13:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51800 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbYC0ANN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 20:13:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47EAE683.7010500@s5r6.in-berlin.de>
Date: Thu, 27 Mar 2008 01:12:51 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: fw-ohci: plug dma memory leak in AR handler
References: <200803251647.16227.jwilson@redhat.com> <200803261737.30717.jwilson@redhat.com>
In-Reply-To: <200803261737.30717.jwilson@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> So as it turns out, while this is indeed a leak that needs to be plugged, it 
> does NOT remedy the 'out of iommu space' issue, it just delays it a while 
> longer. Still working on tracing the root cause of the memory exhaustion.

Do you want to change the wording of the patch description before I 
submit it upstream?
-- 
Stefan Richter
-=====-==--- --== ==-==
http://arcgraph.de/sr/
