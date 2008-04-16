Return-Path: <linux-kernel-owner+w=401wt.eu-S1760285AbYDPDUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbYDPDUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 23:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbYDPDUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 23:20:30 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54256 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbYDPDUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 23:20:30 -0400
Message-ID: <48057076.1010006@us.ibm.com>
Date: Tue, 15 Apr 2008 20:20:22 -0700
From: Badari Pulavarty <pbadari@us.ibm.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       anton@au1.ibm.com
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
References: <1207331616.5916.15.camel@badari-desktop> <20080404180518.GA12642@ldl.fc.hp.com> <1207340371.5916.23.camel@badari-desktop> <20080404224227.GA31436@ldl.fc.hp.com> <1207352128.5916.26.camel@badari-desktop> <20080407234255.GA22514@ldl.fc.hp.com> <20080415173656.218a6080.akpm@linux-foundation.org> <48056DC8.6040909@us.ibm.com> <20080416031828.GC3333@ldl.fc.hp.com>
In-Reply-To: <20080416031828.GC3333@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
>>>> +	if (slot->bus->self)
>>>> +		slot_nr = PCI_SLOT(slot->bus->self->devfn);
>>>> +	else
>>>> +		slot_nr = 0;
>>>> +	retval = pci_hp_register(php_slot, slot->bus, slot_nr);
>>>>  	if (retval) {
>>>>  		err("pci_hp_register failed with error %d\n", retval);
>>>>  		return retval;
>>>>         
>> No. It didn't help. I had to hack "slot_nr = 0" all the time to boot my  
>> machine.
>>     
>
> It didn't help because you're still getting a NULL deref? Or are
> you seeing some other failure mode?
>   
I am pretty sure it was NULL deref. I can double check again, but have 
to wait
till tomorrow morning - don't have access to console right now.

Thanks,
Badari

