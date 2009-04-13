Return-Path: <linux-kernel-owner+w=401wt.eu-S1752350AbZDMRpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbZDMRpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 13:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZDMRo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 13:44:59 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:52003 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZDMRo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 13:44:58 -0400
Message-ID: <49E379FE.8060202@novell.com>
Date: Mon, 13 Apr 2009 13:44:30 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, anthony@codemonkey.ws, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org, bhutchings@solarflare.com,
       andi@firstfloor.org, gregkh@suse.de, herber@gondor.apana.org.au,
       chrisw@sous-sol.org, shemminger@vyatta.com
Subject: Re: [RFC PATCH v2 15/19] kvm: add dynamic IRQ support
References: <20090409155200.32740.19358.stgit@dev.haskins.net> <20090409163200.32740.90490.stgit@dev.haskins.net> <49E0CCDB.4000806@redhat.com>
In-Reply-To: <49E0CCDB.4000806@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>>  
>
> Given that you're using the apic to inject the IRQ, you'll need an
> EOI.  So what's the difference between dynirq and MSI, performance wise?
>

I would have loved to eliminate that EOI completely, but that is a much
broader problem to solve ;)

Actually dynirq wasnt introduced as a performance alternative over MSI. 
Rather, I was trying to eliminate the complexity of needing to sync
between the userspace PCI emulation and the in kernel models.

However, its moot.  Since v2 introduce virtio-vbus, I now have a much
clearer picture of what is needed here, and v3 will simply integrate
with MSI interrupts and drop dynirq completely.  So please ignore this
patch.

-Greg


