Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbXKTBj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbXKTBj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbXKTBju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:39:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49488 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbXKTBjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:39:49 -0500
Message-ID: <47423952.5020204@jp.fujitsu.com>
Date: Tue, 20 Nov 2007 10:33:06 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Gary Hade <garyhade@us.ibm.com>, Alex Chiang <achiang@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
References: <20071117182954.GA25003@ldl.fc.hp.com> <20071119233225.GA6931@us.ibm.com>
In-Reply-To: <20071119233225.GA6931@us.ibm.com>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade ????????:
> On Sat, Nov 17, 2007 at 11:29:54AM -0700, Alex Chiang wrote:
>> Hi all,
>>
>> This is v3 of the pci_slot patch series.
>>
>> The major change is making the ACPI-PCI slot driver a Kconfig
>> option, as per the recommendations of others (Gary, Kenji-san).
> 
> Alex, What I was trying to suggest is a boot-time kernel option, 
> not a kernel configuration option.  The basic idea is to give
> the user (with a single binary kernel) the ability to include
> your ACPI-PCI slot driver feature changes only when they are
> really needed.  In addition to reducing the number of
> system/PCI hotplug driver combinations where your changes
> would need to be validated, I believe would also help 
> alleviate other worries (e.g. Andi Kleen's memory consumption
> concern).  I believe this goal could also be achieved with the
> kernel config option by making the pci_slot module runtime
> loadable with the PCI hotplug drivers only visiting your new
> code when the pci_slot driver is loaded, although I think this
> would be more difficult to implement.
> 

I agree to Gary very much.

Thanks,
Kenji Kaneshige



