Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbZDGI2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbZDGI2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZDGI1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:27:46 -0400
Received: from gw.goop.org ([64.81.55.164]:57627 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbZDGI1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:27:45 -0400
Message-ID: <49DB0E7D.2070300@goop.org>
Date: Tue, 07 Apr 2009 01:27:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Stephen Hemminger <shemminger@vyatta.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Peterson <cpeterso@cpeterso.com>,
       Matt Mackall <mpm@selenic.com>, David Miller <davem@davemloft.net>
Subject: Re: IRQF_SAMPLE_RANDOM question...
References: <200904061430.26276.rgetz@blackfin.uclinux.org>	<49DA4C85.5090806@garzik.org> <20090406114432.3a554eba@nehalam> <49DA4ECC.9050204@garzik.org>
In-Reply-To: <49DA4ECC.9050204@garzik.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Stephen Hemminger wrote:
>> The real problem one is xen-netfront. Because 1) it is least random,
>> the attacker might be another VM 2) the VM is most in need of random
>> samples because it doesn't have real hardware.
>
> Agreed.
>
> I'm surprised Xen doesn't use virtio-rng.  I guess it needs a special 
> Xen paravirt driver for randomness. 

Yes, sampling randomness in a PV driver is pretty pointless.  We could 
do the guest end of an entropy sink entirely in usermode, but at present 
there's no dom0 support for an entropy source.

    J
