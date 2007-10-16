Return-Path: <linux-kernel-owner+w=401wt.eu-S934027AbXJPRfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027AbXJPRfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760775AbXJPRfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:35:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35346 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760524AbXJPRfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:35:21 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4714F652.1060007@s5r6.in-berlin.de>
Date: Tue, 16 Oct 2007 19:35:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Subject: Re: [PATCH] firewire: fw-ohci: fix DMA mapping for ar context
References: <tkrat.2493a847503e3d62@s5r6.in-berlin.de>
In-Reply-To: <tkrat.2493a847503e3d62@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> @@ -253,12 +253,6 @@ static int ar_context_add_page(struct ar
>  	if (ab == NULL)
>  		return -ENOMEM;
>  
> -	ab_bus = dma_map_single(dev, ab, PAGE_SIZE, DMA_BIDIRECTIONAL);
[...]

Argh, it's bogus.  ab_bus is used immediately after that.  Correction
follows in a minute.
-- 
Stefan Richter
-=====-=-=== =-=- =----
http://arcgraph.de/sr/
