Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbXJZAYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbXJZAYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 20:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXJZAYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 20:24:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:1838 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbXJZAYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 20:24:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=naxMtcuU+MinIYKS0o2C9oXHcbugK5WP4mRWLMGVGw/ikm3xH6U26FOcMMfbXde56bojrOn4gqIRWdFOTeikHV6+jiibLTWLxcjq3uovhn6Yu7il/NbsHfetEzjbnIgbmFbBFp1SPRv0FQqDCDfBVzwvR4ggFHQ1h4MYGNQVPEw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/3] ide: fix drive_is_ready() for non-PCI hosts and CONFIG_IDEPCI_SHARE_IRQ=y
Date: Fri, 26 Oct 2007 02:30:52 +0200
User-Agent: KMail/1.9.7
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200710260136.37333.bzolnier@gmail.com> <20071026010515.260672b4@the-village.bc.nu>
In-Reply-To: <20071026010515.260672b4@the-village.bc.nu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710260230.52115.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007, Alan Cox wrote:
> On Fri, 26 Oct 2007 01:36:37 +0200
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > 
> > Need to check if the host is a PCI one before reading IDE_ALTSTATUS_REG.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Umm why ? The altstatus register goes back to ST-506 and the original IBM
> XT hard disk controller card ?

Thought that there have to be some (non-obvious) reason behing the fact that
IDE_ALTSTATUS_REG reading was covered by #ifdef CONFIG_IDEPCI_SHARE_IRQ.

However if this is the case patch #2/3 can be dumped and we can go straight
to patch #3/3.

Thanks,
Bart
