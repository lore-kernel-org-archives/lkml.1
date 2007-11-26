Return-Path: <linux-kernel-owner+w=401wt.eu-S1758325AbXKZCUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbXKZCUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 21:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbXKZCU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 21:20:28 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:64117 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbXKZCU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 21:20:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=W57fZS3lRyjEiaTl7D7Bz2WgXqp4ze52xytzyv5w0QA/EvY3f6+YTU9gZCW4u9v9jyXt7GEDlcyJkwfjW6jNSe1M7uDcgwrqXkmuMIQj5OlIGXVFqg3Smu90Mq9z1Sy4CvqfW2iYw8dXHvVbcWHOT7QasKeVGcKQ+OtxreqyTC4=
Message-ID: <474A2D65.2090302@gmail.com>
Date: Mon, 26 Nov 2007 11:20:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] sata_nv: don't use legacy DMA in ADMA mode (v3)
References: <4749FE58.4060800@shaw.ca>
In-Reply-To: <4749FE58.4060800@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> We need to run any DMA command with result taskfile requested in ADMA mode
> when the port is in ADMA mode, otherwise it may try to use the legacy DMA engine
> in ADMA mode which is not allowed. Enforce this with BUG_ON() since data
> corruption could potentially result if this happened. Also, fail any attempt to
> try and issue NCQ commands with result taskfile requested, since the hardware
> doesn't allow this.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

Acked-by: Tejun Heo <htejun@gmail.com>

Thanks.

-- 
tejun
