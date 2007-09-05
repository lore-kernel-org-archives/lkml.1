Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbXIERf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbXIERf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXIERft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:35:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbXIERfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:35:48 -0400
Message-ID: <46DEE8DC.4000901@redhat.com>
Date: Wed, 05 Sep 2007 13:35:24 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Karl Bellve <Karl.Bellve@umassmed.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: PCI: Unable to reserve mem region problem
References: <46DEBE06.5010401@umassmed.edu>
In-Reply-To: <46DEBE06.5010401@umassmed.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2007 10:32 AM, Karl Bellve wrote:
> 
> Please CC any response. Thanks.
> 
> I am having an issue with a Supermicro h8dce motherboard and failure to
> recognize a 5th SATA drive after upgrading to Fedora 7.
> 
> This motherboard has 8 sata ports that use the sata_nv driver.
> 
> The lack of seeing the 5th SATA drive shows up in 2.6.22 kernels, such
> as kernel-2.6.22.2-42.fc6 and kernel-2.6.22.1-41.fc7.
> 
> The 5th SATA drive can still be detected in 2.6.20 kernels such as
> kernel-2.6.20-1.2933.fc6 (I am currently using this kernel).
> 
> From dmesg, it appears the reason I am not seeing the 5th SATA drive
> (second SATA controller) is the following error:
> 
> Aug 30 14:08:03 alcor kernel: sata_nv 0000:80:08.0: Using ADMA mode
> Aug 30 14:08:03 alcor kernel: PCI: *Unable to reserve mem region*
> #6:1000@dfefd000 for device 0000:80:08.0
> Aug 30 14:08:03 alcor kernel: ACPI: PCI interrupt for device
> 0000:80:08.0 disabled
> Aug 30 14:08:03 alcor kernel: sata_nv: probe of 0000:80:08.0 failed with
> error -16
> 
> sata_nv that comes with the 2.6.22 kernels appear to be version 3.4
> while the older kernels comes with version 3.2 (which work). I contacted
> Robert Hancock directly about this and he suggested I post an email to
> LKML.
> 
> Motherboard:
> http://www.supermicro.com/Aplus/motherboard/Opteron/nForce/H8DCE.cfm
> Single AMD Opteron(tm) Processor 244
> 1 GB of memory.
> 
> I can send you the complete dmesg output if you would like.
> 

Open a bugzilla at https://bugzilla.redhat.com and post full dmesg from
the new and old kernels as attachments there.


There seems to be some kind of memory layout problem in 2.6.22...
