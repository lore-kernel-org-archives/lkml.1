Return-Path: <linux-kernel-owner+w=401wt.eu-S1758929AbXJKVR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbXJKVR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbXJKVRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:17:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45503 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141AbXJKVRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:17:18 -0400
Message-ID: <470E92D8.8060603@garzik.org>
Date: Thu, 11 Oct 2007 17:17:12 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Andi Kleen <ak@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/2] PCI: Add 'nodomains' boot option, and	pci_domains_supported
 global
References: <20071011205727.GA29222@havoc.gtf.org>
In-Reply-To: <20071011205727.GA29222@havoc.gtf.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> * Introduce pci_domains_supported global, hardcoded to zero if
>   !CONFIG_PCI_DOMAINS.
> 
> * Introduce 'nodomains' boot option, which clears pci_domains_supported
>   on platforms that enable it by default (x86, x86-64, and others when
>   they are converted to use this).
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
> Revised per Andi's comments, and split into two patches.
> 
> As found in jgarzik/misc-2.6.git#ALL and jgarzik/misc-2.6.git#pciseg.
> 
>  Documentation/kernel-parameters.txt |    2 ++
>  drivers/pci/pci.c                   |   13 +++++++++++++
>  include/linux/pci.h                 |    7 +++++--
>  3 files changed, 20 insertions(+), 2 deletions(-)

As a note, if this wasn't obvious, this was not implemented in 
x86-specific code because I think other arches can/should be able to 
hook into this.

The default !CONFIG_PCI_DOMAINS implementation continues to work for all 
such arches.


