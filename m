Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbZJIDQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbZJIDQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 23:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760208AbZJIDQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 23:16:44 -0400
Received: from rtr.ca ([76.10.145.34]:38249 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760197AbZJIDQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 23:16:43 -0400
Message-ID: <4ACEAAF5.90304@rtr.ca>
Date: Thu, 08 Oct 2009 23:16:05 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bernie Innocenti <bernie@codewiz.org>
Cc: Harri Olin <harri.olin@gmail.com>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, sysadmin <sysadmin@gnu.org>
Subject: Re: sata_mv 0000:03:06.0: PCI ERROR; PCI IRQ cause=0x30000040
References: <1254546642.1438.135.camel@giskard> <4ACA6904.1060509@rtr.ca>	 <4ACB3741.2030101@gmail.com> <1254852272.1471.172.camel@giskard>	 <4ACBA33C.7090606@rtr.ca>  <1254873978.1471.463.camel@giskard>	 <1254879618.1471.525.camel@giskard>  <4ACC076F.7020000@rtr.ca> <1255020134.30440.698.camel@giskard> <4ACEA8FB.4060901@rtr.ca>
In-Reply-To: <4ACEA8FB.4060901@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Bernie Innocenti wrote:
>>
>> I want to try reducing the frequency of the PCI-X bus, but the BIOS does
>> not seem to provide a setting for it.  Is there another way?
> ..
> 
> Nothing that's easy.
..

Adding to that:  there is a register on the chip,
which software could use to override the normal auto-detected
PCI mode (bus speed) for the chip.  This could be used to,
say, select 100Mhz or 66Mhz, or even 33Mhz operation.

BUT.. the register is autodetected from the bus at power-on,
and so if software wants to override that (by rewriting the reg),
it will also need to reset the PCI bus afterward.

Which requires knowing how to reset a PCI bridge,
something I don't know about.

Cheers
