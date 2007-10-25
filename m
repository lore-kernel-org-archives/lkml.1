Return-Path: <linux-kernel-owner+w=401wt.eu-S1760443AbXJYUHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760443AbXJYUHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760166AbXJYUGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:06:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:46806 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbXJYUGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:06:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=bKHEDFN25Fvf2ZJ1GNdwuzhCIyFIJoZXiRsbpmhguarkmCkUqFjFg+OAQH/TL7BYWgB+uZsV6ctt/Z6rBKspY3vODPhnAnOrfXam/h9jLPcKpvS5Q7luzMqgyoTb9D/aPGcKA2As3RZw3Al40QgqUGwiFgkRrRBPpsaYo+zLXB8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/3] drivers/ide/pci/sc1200.c: fix suspend/resume buglets and warnings
Date: Thu, 25 Oct 2007 22:10:46 +0200
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       akpm@linux-foundation.org
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org> <20071024234825.829191F81A2@havoc.gtf.org>
In-Reply-To: <20071024234825.829191F81A2@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710252210.47072.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007, Jeff Garzik wrote:
> * We shouldn't bother with dev->current_state, the PCI API functions we
>   call manage this for us (and do a far better job at it too).
> 
> * Remove pci_set_power_state(dev, PCI_D0) call in resume, as
>   pci_enable_device() does the same thing.
> 
> * Check pci_enable_device() return value.  If it failed, fail
>   the entire resume and avoid programming timings into the [potentially
>   dead/asleep] chip.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

applied, thanks
