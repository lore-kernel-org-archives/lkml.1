Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbYEVRW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbYEVRW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 13:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbYEVRWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 13:22:48 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:62140 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbYEVRWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 13:22:47 -0400
Message-ID: <4835ABDB.8020901@nortel.com>
Date: Thu, 22 May 2008 11:22:35 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: section mismatch warnings in current git head for powerpc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2008 17:22:39.0079 (UTC) FILETIME=[6F3D2770:01C8BC30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got the following warnings when building current git head for powerpc 
64bit:


   LD      net/ipv4/built-in.o
   LD      drivers/scsi/built-in.o
   LD      net/built-in.o
   LD      drivers/built-in.o
   LD      vmlinux.o
   MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x73bc): Section mismatch in reference from the 
function .start_secondary_prolog() to the function 
.devinit.text:.start_secondary()
The function .start_secondary_prolog() references
the function __devinit .start_secondary().
This is often because .start_secondary_prolog lacks a __devinit
annotation or the annotation of .start_secondary is wrong.

WARNING: vmlinux.o(.text+0x260a8): Section mismatch in reference from 
the function .pci_dn_reconfig_notifier() to the function 
.devinit.text:.update_dn_pci_info()
The function .pci_dn_reconfig_notifier() references
the function __devinit .update_dn_pci_info().
This is often because .pci_dn_reconfig_notifier lacks a __devinit
annotation or the annotation of .update_dn_pci_info is wrong.


Is this anything to worry about?

Thanks,
Chris
