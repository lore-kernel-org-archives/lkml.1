Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbXLBNu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbXLBNu4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 08:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbXLBNus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 08:50:48 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:44649 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbXLBNus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 08:50:48 -0500
Message-ID: <4752B812.7070802@keyaccess.nl>
Date: Sun, 02 Dec 2007 14:50:10 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: trenn@suse.de
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, "Li, Shaohua" <shaohua.li@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Declare PNP option parsing functions as __init
References: <1196442277.23251.318.camel@queen.suse.de>	 <47509EB6.20300@keyaccess.nl> <200711301652.42110.bjorn.helgaas@hp.com>	 <4750ABCB.6090705@keyaccess.nl> <1196602496.4049.51.camel@queen.suse.de>
In-Reply-To: <1196602496.4049.51.camel@queen.suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02-12-07 14:34, Thomas Renninger wrote:

> On Sat, 2007-12-01 at 01:33 +0100, Rene Herman wrote:
>> On 01-12-07 00:52, Bjorn Helgaas wrote:

>>> I agree this is probably safe in the current implementation.
>>>
>>> However, I think the current implementation is just broken because
>>> we can't really handle hotplug of ACPI devices.  Specifically, I think
>>> the first TBD in acpi_bus_check_device() should be fleshed out so it
>>> does something like pnpacpi_add_device().
>>>
>>> So my dissenting opinion is that this patch would just get reverted
>>> soon anyway when somebody finishes implementing ACPI hotplug, and
>>> therefore it's not worth doing.
>> <shrug>
>>
>> The PnPBIOS bits should still be fine at least I guess. And, it would seem 
>> this is rather essential to Thomas' efforts of making this stuff dynamic in 
>> the first place anyway.
> No it is not. It is just another optimization I saw while going through
> these code parts...

Bjorn's argument of making the possible resources runtime dynamic is the 
essential bit, not the patch. You weren't doing that in the simple scheme 
you've outlined till now. Are you or is anyone else now after all?

Rene.

