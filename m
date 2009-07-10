Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbZGJPFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbZGJPFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 11:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZGJPFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 11:05:40 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:39225 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbZGJPFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 11:05:40 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: EHCI, BIOS handoff warning/error?
Date: Fri, 10 Jul 2009 10:05:35 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200907090857.47350.lkml@morethan.org> <4A567F52.1040505@gmail.com>
In-Reply-To: <4A567F52.1040505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907101005.37228.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu July 9 2009, Robert Hancock wrote:
> On 07/09/2009 07:57 AM, Michael S. Zick wrote:
> > Anyone with thoughts on this one?
> > Even a translation of the message might help.
> >
> > pci 0000:00:01.0: disabling DAC on VIA PCI bridge
> > pci 0000:00:10.0: uhci_check_and_reset_hc: legsup = 0x2000
> > pci 0000:00:10.0: Performing full reset
> > pci 0000:00:10.1: uhci_check_and_reset_hc: legsup = 0x2000
> > pci 0000:00:10.1: Performing full reset
> > pci 0000:00:10.2: uhci_check_and_reset_hc: legsup = 0x2000
> > pci 0000:00:10.2: Performing full reset
> > pci 0000:00:10.4: EHCI: BIOS handoff
> > pci 0000:00:10.4: EHCI: BIOS handoff failed (BIOS bug?) 01010001
> > pci 0000:01:00.0: Boot video device
> 
> That would mean the BIOS failed to indicate it has given up control of 
> the EHCI controller within the allowed time period.
>

Thanks.  I'll just toss that one onto the "timing fixups" stack.

Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


