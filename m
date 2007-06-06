Return-Path: <linux-kernel-owner+w=401wt.eu-S965582AbXFFW40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965582AbXFFW40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965378AbXFFW4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:56:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965335AbXFFWz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:55:59 -0400
Message-ID: <46673B76.2090508@redhat.com>
Date: Wed, 06 Jun 2007 18:55:50 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Ian McDonald <ian.mcdonald@jandi.co.nz>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       "David S. Miller" <davem@davemloft.net>,
       Patrick Andrieux <patrick.andrieux@gmail.com>,
       DCCP Mailing List <dccp@vger.kernel.org>
Subject: Re: [BUG] Fwd: segfault : modprobe dccp_probe/tcp_probe
References: <5640c7e00706061347v42c9ecbahb5354f6687a70a78@mail.gmail.com>
In-Reply-To: <5640c7e00706061347v42c9ecbahb5354f6687a70a78@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2007 04:47 PM, Ian McDonald wrote:
> Hi there,
> 
> We've seen a report of a problem with dccp_probe as shown below. The
> user has also verified that it occurs in tcp_probe as well. This is on
> Dave Miller's tree but that currently tracks Linus' tree quite
> closely. I do note that it is around 2.6.22-rc2 timeframe so there is
> a possibility fixes may have gone in since.
> 

It faulted when it tried to write the breakpoint instruction into the
running kernel's executable code. Apparently the kernel code is now marked
read-only?

