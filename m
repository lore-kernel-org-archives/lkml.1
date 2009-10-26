Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZJZNi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZJZNi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbZJZNiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:38:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbZJZNiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:38:25 -0400
Message-ID: <4AE5A650.30609@redhat.com>
Date: Mon, 26 Oct 2009 14:38:24 +0100
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH] PCI hotplug: use correct term for PCI Express
References: <4AE59AE9.6030803@redhat.com> <m3my3emgyw.fsf@intrepid.localdomain>
In-Reply-To: <m3my3emgyw.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.10.2009 14:18, Krzysztof Halasa wrote:
> Stefan Assmann <sassmann@redhat.com> writes:
> 
>> Change PCI-E to PCIe which is the correct term according to
>> http://www.pcisig.com/developers/procedures/logos/Trademark_and_Logo_Usage_Guidelines_updated_112206.pdf.
> 
> Right.
> 
>> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
>> @@ -86,8 +86,8 @@ static char *pci_bus_speed_strings[] = {
>>  	"66 MHz PCIX 533",	/* 0x11 */
>>  	"100 MHz PCIX 533",	/* 0x12 */
>>  	"133 MHz PCIX 533",	/* 0x13 */
>> -	"2.5 GT/s PCI-E",	/* 0x14 */
>> -	"5.0 GT/s PCI-E",	/* 0x15 */
>> +	"2.5 GT/s PCIe",	/* 0x14 */
>> +	"5.0 GT/s PCIe",	/* 0x15 */
> 
> In addition to this, it seems "PCIX" should also be changed to "PCI-X",
> shouldn't it?

Thanks for reminding me Krzysztof. I'll repost a patch with the changes
included.

  Stefan
--
Stefan Assmann         | Red Hat GmbH
Software Engineer      | Otto-Hahn-Strasse 20, 85609 Dornach
                       | HR: Amtsgericht Muenchen HRB 153243
                       | GF: Brendan Lane, Charlie Peters,
sassmann at redhat.com |     Michael Cunningham, Charles Cachera

