Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYAOABb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYAOABb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 19:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYAOABY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 19:01:24 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:58235 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYAOABX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 19:01:23 -0500
Date: Mon, 14 Jan 2008 17:59:43 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
In-reply-to: <fa.EgRiN/duILxBcenHk7dQyC+rldw@ifi.uio.no>
To: Arjan van de Ven <arjan@infradead.org>
Cc: tcamuso@redhat.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Loic Prylli <loic@myri.com>,
       Prarit Bhargava <prarit@redhat.com>,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>,
       Bhavana Nagendra <bnagendr@redhat.com>
Message-id: <478BF76F.8080702@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.KgDY4hzBogAL+o607R+LHzW+HTc@ifi.uio.no>
 <fa.y9bLGEm23C6rL/wz7kMpKYF67oM@ifi.uio.no>
 <fa.S+otiE5kNySVMlhUagdf/n9GRIc@ifi.uio.no>
 <fa.OH5C/OjPYJXn8kSOHV/09piVz0E@ifi.uio.no>
 <fa.jj0GkdAagaR3CLapBSdT1psD3Ps@ifi.uio.no>
 <fa.EgRiN/duILxBcenHk7dQyC+rldw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 13 Jan 2008 22:29:23 -0500
> Tony Camuso <tcamuso@redhat.com> wrote:
> 
>> . There is no need to provide different PCI config access
>>    mechanisms at device granularity, since the PCI config access
>>    mechanism between the CPU and the Northbridge is opaque to
>>    the devices. PCI config mechanisms only need to differ at
>>    the Northbridge level.
> 
> This ignores the "lets make it not matter for the 99% of the users" case.
>> . If the system is capable of conf1, then PCI config access
>>    at offsets < 256 should be confined to conf1. This solution
>>    is most effective for existing and legacy systems.
> 
> not "conf1" but "what the platform thinks is the best method for < 256".
> 
> We have this nice abstraction for the platform to select the best method... we should use it.
> 
> And still, it's another attempt to get this fixed (well.. it's been 2 years in the coming so far, maybe this will
> be the last one, maybe it will not be... we'll see I suppose, but it sucks to be a user who doesn't 
> need any of the functionality that the extended config space provides in theory but gets to suffer more of the issues)

There actually haven't been that many attempts to "get this fixed". It's 
been more a) people complaining about it and nothing being done about 
the problems and b) adding hacks to blindly disable it because of 
reported problems without root-causing why those problems were showing 
up. With such approaches no wonder it has not been reliable to try  and 
use MMCONFIG in the past..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

