Return-Path: <linux-kernel-owner+w=401wt.eu-S1759925AbYDPT7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbYDPT7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 15:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYDPT7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 15:59:40 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:23938 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbYDPT7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 15:59:39 -0400
Date: Wed, 16 Apr 2008 13:59:33 -0600
From: Alex Chiang <achiang@hp.com>
To: ben@kernel.crashing.org
Cc: Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       anton@au1.ibm.com
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
Message-ID: <20080416195933.GB18290@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	ben@kernel.crashing.org, Badari Pulavarty <pbadari@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, anton@au1.ibm.com
References: <1207331616.5916.15.camel@badari-desktop> <20080404180518.GA12642@ldl.fc.hp.com> <1207340371.5916.23.camel@badari-desktop> <20080404224227.GA31436@ldl.fc.hp.com> <1207352128.5916.26.camel@badari-desktop> <20080407234255.GA22514@ldl.fc.hp.com> <20080415173656.218a6080.akpm@linux-foundation.org> <48056DC8.6040909@us.ibm.com> <20080416031828.GC3333@ldl.fc.hp.com> <1208374375.17986.1.camel@badari-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208374375.17986.1.camel@badari-desktop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Badari,

* Badari Pulavarty <pbadari@us.ibm.com>:
> 
> On Tue, 2008-04-15 at 21:18 -0600, Alex Chiang wrote:
> > >>> +	if (slot->bus->self)
> > >>> +		slot_nr = PCI_SLOT(slot->bus->self->devfn);
> > >>> +	else
> > >>> +		slot_nr = 0;
> > >>> +	retval = pci_hp_register(php_slot, slot->bus, slot_nr);
> > >>>  	if (retval) {
> > >>>  		err("pci_hp_register failed with error %d\n", retval);
> > >>>  		return retval;
> > >
> > > No. It didn't help. I had to hack "slot_nr = 0" all the time to boot my  
> > > machine.
> > 
> > It didn't help because you're still getting a NULL deref? Or are
> > you seeing some other failure mode?
> > 
> 
> I verified this patch again. It seem to have worked this time :(
> I am not able to reproduce the problem with this problem (tried many
> times). 
>  
> Sorry for the false alarm :(

Thanks for testing. Please do let me know if you see any more
problems.

Ben, I would still appreciate a code review on:

	http://lkml.org/lkml/2008/4/7/319

Thanks!

/ac

