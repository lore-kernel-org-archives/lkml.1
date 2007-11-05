Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbXKEPIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbXKEPIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 10:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXKEPIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 10:08:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:12711 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbXKEPIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 10:08:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hvdBx3Ser4fM6ED5v8H9fFaFGHgxpGY48h8tYU0EV+gk5G5UrsYSraErZOENU/tZKjzV9azAyYoAmhXD0J7yePE3LHzfJJZbWeVFSUaDIBQpb2mQT25VLTmQzqLgKGbkfpjWB6aLvEWjKSs5kSxWgNH/w3HI2Xx8nbLH5CGZdLo=
Message-ID: <472F31F4.5080604@gmail.com>
Date: Mon, 05 Nov 2007 16:08:36 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jesper Nilsson <jesper.nilsson@axis.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRISv10 serial driver rewrite take three
References: <20071105143115.GO7621@axis.com>
In-Reply-To: <20071105143115.GO7621@axis.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2007 03:31 PM, Jesper Nilsson wrote:
> New and improved serial driver for CRISv10, take three, with improvements
> suggested by Jiri Slaby.
> 
> - Call wait_event_interruptible with a _correct_ and sensible condition.
> - Removed superfluous test of info->flags & ASYNC_CLOSING, since that is done
>   by wait_event_interruptible.
> - Moved common code for deregistering DMA and IRQ to deinit_port function.
> - Use setup_timer when initializing flush_timer.
> - Convert bit-field for uses_dma_in and uses_dma_out to regular bytes.
> - Removed CVS tags.
> - Removed defines and comments for CRIS_BUF_SIZE and TTY_THRESHOLD_THROTTLE
>   (no longer used).
> - Cleaned up code to pass checkpatch.
> - Add crisv10.h header file.
> - Merge of CRISv10 from Axis internal CVS.
> 
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

Reviewed-by: Jiri Slaby <jirislaby@gmail.com>

> ---
>  drivers/serial/crisv10.c         | 1293 ++++++++++++-------------------------
>  drivers/serial/crisv10.h         |  146 ++++
>  2 files changed, 580 insertions(+), 859 deletions(-)
