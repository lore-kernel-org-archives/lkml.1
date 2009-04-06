Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbZDFSuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbZDFSuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 14:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbZDFSty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 14:49:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45733 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708AbZDFSty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 14:49:54 -0400
Message-ID: <49DA4ECC.9050204@garzik.org>
Date: Mon, 06 Apr 2009 14:49:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Robin Getz <rgetz@blackfin.uclinux.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Peterson <cpeterso@cpeterso.com>,
       Matt Mackall <mpm@selenic.com>, David Miller <davem@davemloft.net>
Subject: Re: IRQF_SAMPLE_RANDOM question...
References: <200904061430.26276.rgetz@blackfin.uclinux.org>	<49DA4C85.5090806@garzik.org> <20090406114432.3a554eba@nehalam>
In-Reply-To: <20090406114432.3a554eba@nehalam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> The real problem one is xen-netfront. Because 1) it is least random,
> the attacker might be another VM 2) the VM is most in need of random
> samples because it doesn't have real hardware.

Agreed.

I'm surprised Xen doesn't use virtio-rng.  I guess it needs a special 
Xen paravirt driver for randomness.

	Jeff


