Return-Path: <linux-kernel-owner+w=401wt.eu-S1762273AbXKOBjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762273AbXKOBjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 20:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbXKOBjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 20:39:10 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:9451 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776AbXKOBjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 20:39:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=NdxL+jbuld7l22imlSA83dT+o63bZNtfWHmk/O4nMNsfkF/WYmkn+E68zxZfh8MAhHBavV+SxId2sWAvJlVjVWn/Q37sLJjrFvywcfUeiMmM/zeU+ljxdl6WLCeweUn9Vas4wIaraTTJ3EkG+xd34YNoglEKMwsYNSt5UvJVO3E=
Message-ID: <473BA332.9030406@gmail.com>
Date: Thu, 15 Nov 2007 10:38:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2/2] sata_nv: fix ATAPI issues with memory over 4GB (v3)
References: <473A7677.6080007@shaw.ca>
In-Reply-To: <473A7677.6080007@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> This fixes some problems with ATAPI devices on nForce4 controllers in ADMA mode
> on systems with memory located above 4GB. We need to delay setting the 64-bit
> DMA mask until the PRD table and padding buffer are allocated so that they don't
> get allocated above 4GB and break legacy mode (which is needed for ATAPI
> devices).
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

applied to #tj-upstream-fixes.

-- 
tejun
