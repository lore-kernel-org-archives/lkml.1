Return-Path: <linux-kernel-owner+w=401wt.eu-S932962AbXHFXLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbXHFXLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762192AbXHFXLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:11:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42111 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764237AbXHFXLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:11:06 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46B7AA77.4020505@s5r6.in-berlin.de>
Date: Tue, 07 Aug 2007 01:10:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.5) Gecko/20070804 SeaMonkey/1.1.3
MIME-Version: 1.0
To: Olaf Hering <olh@suse.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix crash in sbp2_remove_device() when dma_set_mask()
 fails
References: <20070806122059.GA1951@suse.de>
In-Reply-To: <20070806122059.GA1951@suse.de>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering wrote:
> Fix crash in sbp2_remove_device() when dma_set_mask() fails.

Thanks for finding this.  I will examine the allocation and deallocation
paths once more with your fix side by side later today, then move it
upstream.
-- 
Stefan Richter
-=====-=-=== =--- --===
http://arcgraph.de/sr/
