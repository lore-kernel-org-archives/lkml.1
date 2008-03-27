Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbYC0CSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbYC0CSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 22:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYC0CRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 22:17:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbYC0CRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 22:17:51 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: fw-ohci: plug dma memory leak in AR handler
Date: Wed, 26 Mar 2008 22:17:29 -0400
User-Agent: KMail/1.9.9
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200803251647.16227.jwilson@redhat.com> <200803261737.30717.jwilson@redhat.com> <47EAE683.7010500@s5r6.in-berlin.de>
In-Reply-To: <47EAE683.7010500@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803262217.29064.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 March 2008 08:12:51 pm Stefan Richter wrote:
> Jarod Wilson wrote:
> > So as it turns out, while this is indeed a leak that needs to be plugged,
> > it does NOT remedy the 'out of iommu space' issue, it just delays it a
> > while longer. Still working on tracing the root cause of the memory
> > exhaustion.
>
> Do you want to change the wording of the patch description before I
> submit it upstream?

Yeah, I'll whip something up in just a sec and get it out the door...

-- 
Jarod Wilson
jwilson@redhat.com
