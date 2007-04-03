Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbXDCFep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbXDCFep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 01:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbXDCFep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 01:34:45 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:35135 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbXDCFeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 01:34:44 -0400
Date: Tue, 3 Apr 2007 06:34:37 +0100 (BST)
From: Christian Kujau <christian@g-house.de>
X-X-Sender: evil@sheep.housecafe.de
To: Chuck Ebbert <cebbert@redhat.com>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, malte@g-house.de
Subject: Re: 2.6.20.4: NETDEV WATCHDOG and lockups
In-Reply-To: <46116570.3050109@redhat.com>
Message-ID: <Pine.LNX.4.64.0704030633200.3963@sheep.housecafe.de>
References: <Pine.LNX.4.64.0704022012300.3963@sheep.housecafe.de>
 <46116570.3050109@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Chuck Ebbert wrote:
> Where is the info from before you changed to "noapic"? Or were the
> machines always using XT-PIC for all the interrupts???

XT-PIC is only used since we switched to noapic, before there was 
IO-APIC-fasteoi on both ethernet cards and interrupts were balanced 
well.

Thanks,
Christian.
-- 
BOFH excuse #340:

Well fix that in the next (upgrade, update, patch release, service pack).
