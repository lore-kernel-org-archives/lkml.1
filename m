Return-Path: <linux-kernel-owner+w=401wt.eu-S965953AbXDBVeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965953AbXDBVeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965954AbXDBVeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:34:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58204 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965953AbXDBVeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:34:03 -0400
Message-ID: <4611768D.1080801@garzik.org>
Date: Mon, 02 Apr 2007 17:33:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
Subject: Re: A set of "standard" virtual devices?
References: <4611652F.700@zytor.com> <46116E12.5070206@goop.org> <200704022312.39195.ak@suse.de>
In-Reply-To: <200704022312.39195.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> How would that work in the case where virtualized guests don't have a
>> visible PCI bus, and the virtual environment doesn't pretend to emulate
>> a PCI bus?
> 
> If they emulated one with the appropiate device 
> then distribution driver auto probing would just work transparently for them.

Yes, but, ideally with paravirtualization you should be able to avoid 
the overhead of emulating many major classes of device (storage, 
network, RNG, etc.) by developing a low-overhead passthrough interface 
that does not involve PCI at all.

	Jeff


