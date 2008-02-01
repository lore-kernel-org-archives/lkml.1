Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbYBAQcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbYBAQcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbYBAQb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:31:59 -0500
Received: from dgate2.fujitsu-siemens.com ([217.115.66.36]:54353 "EHLO
	dgate2.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754335AbYBAQb6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:31:58 -0500
X-Greylist: delayed 815 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2008 11:31:58 EST
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:Received:Received:
   From:To:Date:Subject:Thread-Topic:Thread-Index:Message-ID:
   Accept-Language:Content-Language:X-MS-Has-Attach:
   X-MS-TNEF-Correlator:acceptlanguage:Content-Type:
   Content-Transfer-Encoding:MIME-Version;
  b=OGpunsRgEqzEJmFRXb79V7e0WnKWBPKijUXz2HvqU0XEbeSIrq13e4sv
   YvwenWfz/yHRN4bcPnNGiFZHSXkHtnGRUgZjQLD+/xkm2b35p16KykLmW
   W4A6EUqM1ob5TAs;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.25,290,1199660400"; 
   d="scan'208";a="25156727"
From: "Cestonaro, Thilo" <Thilo.Cestonaro@fujitsu-siemens.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 1 Feb 2008 17:17:25 +0100
Subject: pci_alloc_consistent and memory >= 4GB pre CONFIG_ZONE_DMA32
Thread-Topic: pci_alloc_consistent and memory >= 4GB pre CONFIG_ZONE_DMA32
Thread-Index: Achk7e7H+TRzVclfTVqsKjJFk8dBQw==
Message-ID: <1C27BF3FB8EE3A4D8F901C22ADE1DE0768043556ED@ABGEX72E.FSC.NET>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

I've a problem with pci_alloc_consistent with Kernel 2.6.5 and memory >= 4GB on a x86_64 machine.
The device can't use the dma_addr which I retrieve from pci_alloc_consistent.
But if the machine has less then 4GB it works fine.

How can I prove that the adress I get from pci_alloc_consistent is dma compatible?
Should pci_alloc_consistent not be used in environments before CONFIG_ZONE_DMA32?

Is there a better way to get dma compatible memory since 2.6.1 (except using kmalloc and GFP_DMA, cause just below 16MB is not enough memory)?

I'm very appreciative for any answer / help.

Ciao Thilo
