Return-Path: <linux-kernel-owner+w=401wt.eu-S2993084AbXDTSFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993084AbXDTSFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 14:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993310AbXDTSFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 14:05:24 -0400
Received: from sanctuary.goth.net ([64.27.17.130]:49327 "EHLO mail.goth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993084AbXDTSFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 14:05:23 -0400
Message-ID: <462900BD.8020204@goth.net>
Date: Fri, 20 Apr 2007 14:04:45 -0400
From: "Preston A. Elder" <prez@goth.net>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, "Preston A. Elder" <prez@goth.net>,
       linux-kernel@vger.kernel.org
Subject: Re: AGPGart / AMD K7
References: <46286775.5000507@goth.net> <20070420155537.GA20118@redhat.com> <4628F00B.3010304@goth.net> <20070420173337.GD20118@redhat.com>
In-Reply-To: <20070420173337.GD20118@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Fri, Apr 20, 2007 at 12:53:31PM -0400, Preston A. Elder wrote:
>
>  > Linux agpgart interface v0.101 (c) Dave Jones
>  > agpgart: DEBUG 0
>  > agpgart: DEBUG 1
>  > __pci_register_driver: In function
>  > __pci_register_driver: driver = agpgart-amdk7, multithread = 0
>  > __pci_register_driver: Before Spinlock
>  > __pci_register_driver: Before List Init
>  > __pci_register_driver: Before Driver Register
>  > __pci_register_driver: Error = 0
>  > __pci_register_driver: Returning 0
>  > 
>  > The DEBUG 0 and 1 are coming from agp_amdk7_init()
>  > There is a DEBUG 2 at the top of agp_amdk7_probe(), even before
>  > pci_find_capability, but the function never gets called.
>
> bus_add_driver() returns 0 on error, but there's a few different
> cases it can fail, which isn't helpful.  Add some printk's to
> the error cases there, and see if that gives any more clues.
>
> 	Dave
>
>   
Here you go:

Linux agpgart interface v0.101 (c) Dave Jones
agpgart: DEBUG 0
agpgart: DEBUG 1
__pci_register_driver: In function
__pci_register_driver: driver = agpgart-amdk7, multithread = 0
__pci_register_driver: Before Spinlock
__pci_register_driver: Before List Init
__pci_register_driver: Before Driver Register
bus_add_driver: In Function
bus_add_driver: Before kobject_set_name (agpgart-amdk7)
bus_add_driver: error = 0
bus_add_driver: Before kobject_register
bus_add_driver: error = 0
bus_add_driver: Before driver_attach
bus_add_driver: error = 0
bus_add_driver: Before klist_add_tail
bus_add_driver: Before module_add_driver
bus_add_driver: Before driver_add_attrs
bus_add_driver: error = 0
bus_add_driver: Before add_bind_files
bus_add_driver: error = 0
bus_add_driver: Returning 0
__pci_register_driver: Error = 0
__pci_register_driver: Returning 0


PreZ :)
