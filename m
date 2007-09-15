Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbXIOUZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbXIOUZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 16:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbXIOUZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 16:25:10 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:59310 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbXIOUZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 16:25:08 -0400
Date: Sat, 15 Sep 2007 14:24:45 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
In-reply-to: <fa.lPg6OSzX+f6jdXK1ZF0rlIhZok4@ifi.uio.no>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       Matthew Wilcox <matthew@wil.cx>, Shaohua Li <shaohua.li@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Message-id: <46EC3F8D.4040702@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.+WRenB38novq157RnGPLoU4q2XI@ifi.uio.no>
 <fa.mM7Va6Nlsaduo/AF4MkeurSBTbs@ifi.uio.no>
 <fa.Ff0IMhMYWp7NYEdjO0AftHzVOh4@ifi.uio.no>
 <fa.d9zBdhHd9gKcJbtwrYguusbECo4@ifi.uio.no>
 <fa.TLO57rS9iV7zhomQxJbV9gjbxx8@ifi.uio.no>
 <fa.lPg6OSzX+f6jdXK1ZF0rlIhZok4@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On 9/14/07, Robert Hancock <hancockr@shaw.ca> wrote:
>> It's not impossible at all. In fact I'm quite sure (Jesse can confirm)
>> that in the case of the board he was using, it was an add-in graphics
>> card where he saw this problem.
>>
>> The fact is that in the case of MMCONFIG overlap with PCI BARs, which
>> one takes priority is completely undefined. In the case of this Intel
>> chipset, clearly the PCI Express device connected to the northbridge had
>> higher decode priority than the MMCONFIG aperture.
> 
> can you relocate the MMCONFIG above RAM range? for example 512G...

On some chipsets that might be possible, however I think that on the 
Intel ones it's not possible to move it above 4G. And in any case this 
would require chipset-specific knowledge, which we would rather not have 
to need.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

