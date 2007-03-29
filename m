Return-Path: <linux-kernel-owner+w=401wt.eu-S1030522AbXC2RZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030522AbXC2RZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 13:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030519AbXC2RZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 13:25:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030521AbXC2RZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 13:25:50 -0400
Message-ID: <460BF68E.9030806@redhat.com>
Date: Thu, 29 Mar 2007 13:25:34 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mitch Williams <mitch.a.williams@intel.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, auke-jan.h.kok@intel.com
Subject: Re: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table (rev 2)
References: <1175186462.21369.4.camel@strongmad>
In-Reply-To: <1175186462.21369.4.camel@strongmad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mitch Williams wrote:
> This patch fixes a kernel bug which is triggered when using the
> irqbalance daemon with MSI-X hardware.
> 
> Because both MSI-X interrupt messages and MSI-X table writes are posted,
> it's possible for them to cross while in-flight.  This results in
> interrupts being received long after the kernel thinks they're disabled,
> and in interrupts being sent to stale vectors after rebalancing.
> 
> This patch performs a read flush after writes to the MSI-X table for
> mask/unmask and rebalancing operations.
> 
> This patch has been validated with (unreleased) network hardware which
> uses MSI-X.
> 
> Revised with input from Eric Biederman.
> 
> Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
> 

Are you going to post one for 2.6.20 as well? Some people might be
interested...


