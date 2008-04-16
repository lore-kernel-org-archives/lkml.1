Return-Path: <linux-kernel-owner+w=401wt.eu-S1761120AbYDPDSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761120AbYDPDSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 23:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbYDPDS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 23:18:29 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:9589 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbYDPDS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 23:18:29 -0400
Date: Tue, 15 Apr 2008 21:18:28 -0600
From: Alex Chiang <achiang@hp.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       anton@au1.ibm.com
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
Message-ID: <20080416031828.GC3333@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Badari Pulavarty <pbadari@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, anton@au1.ibm.com
References: <1207331616.5916.15.camel@badari-desktop> <20080404180518.GA12642@ldl.fc.hp.com> <1207340371.5916.23.camel@badari-desktop> <20080404224227.GA31436@ldl.fc.hp.com> <1207352128.5916.26.camel@badari-desktop> <20080407234255.GA22514@ldl.fc.hp.com> <20080415173656.218a6080.akpm@linux-foundation.org> <48056DC8.6040909@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48056DC8.6040909@us.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +	if (slot->bus->self)
>>> +		slot_nr = PCI_SLOT(slot->bus->self->devfn);
>>> +	else
>>> +		slot_nr = 0;
>>> +	retval = pci_hp_register(php_slot, slot->bus, slot_nr);
>>>  	if (retval) {
>>>  		err("pci_hp_register failed with error %d\n", retval);
>>>  		return retval;
>
> No. It didn't help. I had to hack "slot_nr = 0" all the time to boot my  
> machine.

It didn't help because you're still getting a NULL deref? Or are
you seeing some other failure mode?

Thanks.

/ac

