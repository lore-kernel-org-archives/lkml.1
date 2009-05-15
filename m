Return-Path: <linux-kernel-owner+w=401wt.eu-S1763289AbZEOSRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763289AbZEOSRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762036AbZEOSQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:16:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39756 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760116AbZEOSQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:16:56 -0400
Message-ID: <4A0DB196.8010209@garzik.org>
Date: Fri, 15 May 2009 14:16:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, daveliu@freescale.com
Subject: Re: [PATCH] sata_fsl: Fix the command description of FSL SATA controller
References: <Pine.LNX.4.64.0905140945540.8378@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0905140945540.8378@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> From: Dave Liu <daveliu@freescale.com>
> 
> The bit 11 of command description is reserved bit in Freescale
> SATA controller and needs to be set to '1'.  This is needed to
> make sure the last write from the controller to the buffer
> descriptor is seen before an interrupt is raised.
> 
> Signed-off-by: Dave Liu <daveliu@freescale.com>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> 
> Jeff, please pick this up as a bug fix for 2.6.30
> 
>  drivers/ata/sata_fsl.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)

applied


