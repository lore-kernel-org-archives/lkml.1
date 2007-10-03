Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbXJCSn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbXJCSn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXJCSnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:43:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36676 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbXJCSnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:43:19 -0400
Message-ID: <4703E2C5.40502@pobox.com>
Date: Wed, 03 Oct 2007 14:43:17 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: fix for sata_mv >64KB DMA segments
References: <20071001220439.GA15332@lixom.net> <470176B8.1000109@pobox.com> <20071002023000.GA19286@lixom.net> <4702D2DE.1050504@pobox.com> <20071003014527.GA6316@lixom.net>
In-Reply-To: <20071003014527.GA6316@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> Fix bug in sata_mv for cases where the IOMMU layer has merged SG entries
> to larger than 64KB. They need to be split up before being sent to
> the driver.
> 
> Just for simplicity's sake, split up at 64K boundary instead of 64K size,
> since that's what the common code does anyway.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>

applied, good catch, thanks!


