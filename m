Return-Path: <linux-kernel-owner+w=401wt.eu-S1762392AbYBHC3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762392AbYBHC3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 21:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYBHC3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 21:29:13 -0500
Received: from colo.lackof.org ([198.49.126.79]:37179 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbYBHC3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 21:29:12 -0500
Date: Thu, 7 Feb 2008 19:28:54 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Tony Camuso <tcamuso@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
Message-ID: <20080208022854.GF28163@colo.lackof.org>
References: <479E1FA6.1030708@redhat.com> <20080128204431.GA15227@kroah.com> <20080128223141.GA31101@parisc-linux.org> <20080128225334.GD4720@kroah.com> <20080129025615.GC20198@parisc-linux.org> <20080129030340.GE20198@parisc-linux.org> <86802c440802022330o771cf98btcf750c790668b6e9@mail.gmail.com> <47AB299D.4000500@redhat.com> <20080207082827.2b4e6112@laptopd505.fenrus.org> <47AB3382.3030806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AB3382.3030806@redhat.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 11:36:18AM -0500, Tony Camuso wrote:
> Arjan van de Ven wrote:
>> On Thu, 07 Feb 2008 10:54:05 -0500
>> Tony Camuso <tcamuso@redhat.com> wrote:
>>> Matthew,
>>>
>>> Perhaps I missed it, but did you address Yinghai's concerns?
>>>
>>> Yinghai Lu wrote:
>>>> On Jan 28, 2008 7:03 PM, Matthew Wilcox <matthew@wil.cx> wrote:
>>>>> -int pci_conf1_write(unsigned int seg, unsigned int bus,
>>>>> +static int pci_conf1_write(unsigned int seg, unsigned int bus,
>>>>>                            unsigned int devfn, int reg, int len,
>>>>> u32 value)
>>>> any reason to change pci_conf1_read/write to static?
>>>>
>> nothing should use these directly. So static is the right answer ;)
>
> Agreed. Thanks, Arjan.
>
> Matthew,
> What about the ATA_RAM addition to Kconfig? Was it accidental,
> or intended? If intended, how is it related?

AFAICT, it looks accidental. I can't see how it's related.
He should be back online next week and can answer for himself.

hth,
grant
