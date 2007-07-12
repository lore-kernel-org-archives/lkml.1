Return-Path: <linux-kernel-owner+w=401wt.eu-S935934AbXGLCtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935934AbXGLCtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 22:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935095AbXGLCtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 22:49:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48658 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934458AbXGLCtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 22:49:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46959651.1050400@s5r6.in-berlin.de>
Date: Thu, 12 Jul 2007 04:47:45 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Yinghai.Lu@Sun.COM
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, rientjes@google.com,
       Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] try parent numa_node at first before using default
References: <200707101641.17672.yinghai.lu@sun.com> <200707101652.31378.yinghai.lu@sun.com> <4694B702.2050507@s5r6.in-berlin.de> <20070711210833.GA22745@kroah.com> <46954B92.8000407@sun.com>
In-Reply-To: <46954B92.8000407@sun.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> original default is -1, and this patch just try to use parent's node as
> default.

But in many cases, the patch does so at a time when the parent is not
yet known.
-- 
Stefan Richter
-=====-=-=== -=== -==--
http://arcgraph.de/sr/
