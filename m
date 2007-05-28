Return-Path: <linux-kernel-owner+w=401wt.eu-S1761739AbXE1WeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761739AbXE1WeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbXE1WeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:34:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48848 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbXE1WeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:34:09 -0400
Message-ID: <465B58DE.1010308@garzik.org>
Date: Mon, 28 May 2007 18:34:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: divy@chelsio.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 1/7] cxgb3 - Fix SGE page management
References: <20070526225947.12097.82363.stgit@localhost.localdomain>
In-Reply-To: <20070526225947.12097.82363.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

divy@chelsio.com wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Streamline page management on RX.
> Fix dma mappings.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

NAK #1:  "streamline" is not a bug-fixes-only change, which is the only 
type of change appropriate for 2.6.22-rc.

NAK #2:  You should use the page_address(page) accessor rather than 
creating a struct member in the same struct as your page, solely to 
contain the virtual address.


