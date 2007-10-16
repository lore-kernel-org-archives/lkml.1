Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbXJPQHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbXJPQHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbXJPQHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:07:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53044 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbXJPQHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:07:38 -0400
Message-ID: <4714E1C7.1090502@garzik.org>
Date: Tue, 16 Oct 2007 12:07:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Konstantin Kalin <konstantin.kalin@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: NVIDIA Ethernet & invalid MAC
References: <4714C66D.4010607@gmail.com> <4714E00D.2000505@redhat.com>
In-Reply-To: <4714E00D.2000505@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> Konstantin Kalin wrote:
>> P.S. It's simple to add DEV_HAS_CORRECT_MACADDR to pci_device_tlb for 
>> these types of Ethernet. But I think it's not right decision because 
>> it would break older revisions of these models.
> 
> Any reason you can't distinguish based on PCI ID?

That's presumably what he means, when he references the PCI device ID table.

But to establish that on a per-ID basis, we have to get some idea of the 
sample set.  You cannot just make the decision based on PCI ID alone, 
because that PCI ID can (and does) apply to multiple BIOS vendors.

	Jeff



