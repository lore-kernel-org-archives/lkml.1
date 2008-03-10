Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbYCJXNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbYCJXNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbYCJXMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:12:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:52219 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbYCJXMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:12:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=JYiIVQeMN8z0RhAI1imQnAYnFjKGqTmmEfCX1lW6lUfue9wBRZ+R/W8hI35xl6oXQ9s9b2ME0XInYfF9yvBk74qHS9bwoDKpa2qK64V9A8maJXwifUEDZ7+M+m8n74gQdqnsCKaTTbWcU91522iGBEzC7cyGK6SgVbVQQ1uQ4p4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 4/4] ide: constify struct ide_dma_ops
Date: Mon, 10 Mar 2008 22:53:30 +0100
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200803091702.18521.bzolnier@gmail.com> <47D417DD.20404@ru.mvista.com>
In-Reply-To: <47D417DD.20404@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803102253.30988.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 09 March 2008, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> > * Export ide_dma_exec_cmd() and __ide_dma_test_irq().
> 
> > * Constify struct ide_dma_ops.
> 
> > * Always set hwif->dma_ops to &sff_dma_ops in ide_setup_dma()
> >   (it is later overriden by ide_init_port() if needed) and drop
> >   'const struct ide_port_info *d' argument.
> 
> > While at it:
> 
> > * Rename __ide_dma_test_irq() to __ide_dma_test_irq().
> 
>     Huh? :-)

thanks, fixed (the latter should be ide_dma_test_irq() of course)
