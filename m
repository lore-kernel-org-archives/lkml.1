Return-Path: <linux-kernel-owner+w=401wt.eu-S1763415AbYDPTdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763415AbYDPTdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYDPTcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:32:53 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38084 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbYDPTcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:32:53 -0400
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Alex Chiang <achiang@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       anton@au1.ibm.com
In-Reply-To: <20080416031828.GC3333@ldl.fc.hp.com>
References: <1207331616.5916.15.camel@badari-desktop>
	 <20080404180518.GA12642@ldl.fc.hp.com>
	 <1207340371.5916.23.camel@badari-desktop>
	 <20080404224227.GA31436@ldl.fc.hp.com>
	 <1207352128.5916.26.camel@badari-desktop>
	 <20080407234255.GA22514@ldl.fc.hp.com>
	 <20080415173656.218a6080.akpm@linux-foundation.org>
	 <48056DC8.6040909@us.ibm.com>  <20080416031828.GC3333@ldl.fc.hp.com>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 12:32:55 -0700
Message-Id: <1208374375.17986.1.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-15 at 21:18 -0600, Alex Chiang wrote:
> >>> +	if (slot->bus->self)
> >>> +		slot_nr = PCI_SLOT(slot->bus->self->devfn);
> >>> +	else
> >>> +		slot_nr = 0;
> >>> +	retval = pci_hp_register(php_slot, slot->bus, slot_nr);
> >>>  	if (retval) {
> >>>  		err("pci_hp_register failed with error %d\n", retval);
> >>>  		return retval;
> >
> > No. It didn't help. I had to hack "slot_nr = 0" all the time to boot my  
> > machine.
> 
> It didn't help because you're still getting a NULL deref? Or are
> you seeing some other failure mode?
> 

Alex,

I verified this patch again. It seem to have worked this time :(
I am not able to reproduce the problem with this problem (tried many
times). 
 
Sorry for the false alarm :(

Thanks,
Badari

