Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZGZKFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZGZKFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 06:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbZGZKFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 06:05:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:1688 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbZGZKFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 06:05:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lUcxEnZrKKwhU632xDubwvI4poAIWnb04n9CmtijsHTuuJFDQ/4emP38qY6HdQQd5C
         M4PHLXvs8e9GAnqq/W9qNotbX80QCZfzUPuk9KwsqwxX0aQskDvWtYzKPKF1QnFVnM8A
         pGNhaKYSTrZ2AocNQ3aJVRnkPXp9S4Z5GRkEo=
MIME-Version: 1.0
In-Reply-To: <1248099954-6666-1-git-send-email-tom.leiming@gmail.com>
References: <1248099954-6666-1-git-send-email-tom.leiming@gmail.com>
Date: Sun, 26 Jul 2009 18:05:41 +0800
Message-ID: <d82e647a0907260305i4cceaf07p3029f9ea3eb482cd@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] ARM:dma-mapping:DMA-API debugging patch set
From: Ming Lei <tom.leiming@gmail.com>
To: linux@arm.linux.org.uk, rmk@arm.linux.org.uk
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/20  <tom.leiming@gmail.com>:
> From: Ming Lei <tom.leiming@gmail.com>
>
> Hi,
> This patch set introduces dma-api debugging facility on ARM, and is
> against -rc3-next tree.
>
> Based on the feedback from Russell King, this version removes
> unnecessary calling of debug_dma_map_page and debug_dma_unmap_page
> in dma_map_sg and dma_unmap_sg respectively.
>
>  arch/arm/Kconfig                   |    1 +
>  arch/arm/common/dmabounce.c        |   12 ++--
>  arch/arm/include/asm/dma-mapping.h |  114 +++++++++++++++++++++++++++++-------
>  arch/arm/mm/dma-mapping.c          |   41 ++++++++-----
>  4 files changed, 126 insertions(+), 42 deletions(-)

Hi, Russell

Is this version OK for you now?

Thanks.

-- 
Lei Ming
