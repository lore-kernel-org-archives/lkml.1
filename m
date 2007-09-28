Return-Path: <linux-kernel-owner+w=401wt.eu-S1760934AbXI1BjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760934AbXI1BjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 21:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759956AbXI1BjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 21:39:14 -0400
Received: from mx1.suse.de ([195.135.220.2]:60098 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759796AbXI1BjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 21:39:14 -0400
Date: Thu, 27 Sep 2007 18:37:15 -0700
From: Greg KH <gregkh@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>, Brice Goglin <Brice.Goglin@ens-lyon.org>,
       torvalds@osdl.org, Andrew Morton <akpm@osdl.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: State of the Linux PCI Subsystem for 2.6.23-rc8
Message-ID: <20070928013715.GA22596@suse.de>
References: <20070926210010.GC1734@kroah.com> <46FAD1EA.6090504@ens-lyon.org> <20070926213931.GA24049@suse.de> <46FB5A3B.4020801@garzik.org> <20070927153438.GC30419@kroah.com> <46FC567A.3030801@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FC567A.3030801@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 09:18:50PM -0400, Jeff Garzik wrote:
> Greg KH wrote:
>> On Thu, Sep 27, 2007 at 03:22:35AM -0400, Jeff Garzik wrote:
>>> Greg KH wrote:
>>>> On Wed, Sep 26, 2007 at 11:40:58PM +0200, Brice Goglin wrote:
>>>>> Greg KH wrote:
>>>>>> Here's a summary of the current state of the Linux PCI subsystem, as 
>>>>>> of
>>>>>> 2.6.23-rc8.
>>>>>>
>>>>>> If the information in here is incorrect, or anyone knows of any
>>>>>> outstanding issues not listed here, please let me know.
>>>>>>
>>>>>> List of outstanding regressions from 2.6.22:
>>>>>> 	- none known.
>>>>>>
>>>>>> List of outstanding regressions from older kernel versions:
>>>>>> 	- none known.
>>>>>>   
>>>>> What about http://marc.info/?l=linux-pci&m=119072400008538&w=2 ?
>>>> That's not a regression, right?  Tt's probably never worked for that
>>>> kind of box :)
>>>> I think the pci bus patches that are pending from Jeff Garzik should fix
>>>> up these issues.  They are in one of his trees, and in the -mm release,
>>>> if you are able to test those.
>>> jgarzik/misc-2.6.git#pciseg has my only outstanding PCI stuff, which is a 
>>> small x86[-64] PCI domain support patch.  Mostly unrelated to the thread 
>>> at hand, alas, even though it was touching that area.
>>>
>>> I need to a few changes required by Andi, who made several good points, 
>>> then the PCI domains thing should be ready for upstream.  I don't care 
>>> much who merges it, you, Andi or me.
>> I'll take it, as I guess it should go through me, Andi is going to have
>> enough merge issues for 2.6.24 :)
>> I'll add them to my tree later today.
>
> Please don't pull 'pciseg' just yet...  it needs the fixes Andi pointed 
> out, namely, it should be turned on by default in x86 / x86-64 platform 
> Kconfig, and have a boot-time method of disabling it.

Ok, let me know when you want me to pull it and I will.  Or just send me
the patches by email, that's much easier for me :)

thanks,

greg k-h
