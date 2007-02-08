Return-Path: <linux-kernel-owner+w=401wt.eu-S1423040AbXBHI4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423040AbXBHI4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 03:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423061AbXBHI4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 03:56:30 -0500
Received: from warden-p.diginsite.com ([208.29.163.248]:37281 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1423040AbXBHI43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 03:56:29 -0500
Date: Thu, 8 Feb 2007 00:42:43 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Marc Donner <donner@dbd-breitband.de>, linux-kernel@vger.kernel.org
Subject: Re: cpu load balancing problem on smp
In-Reply-To: <45C96AC1.4030301@linux.intel.com>
Message-ID: <Pine.LNX.4.63.0702080040550.2981@qynat.qvtvafvgr.pbz>
References: <200702061832.17771.donner@dbd-breitband.de> 
 <200702061941.32907.donner@dbd-breitband.de>  <45C8CC2A.90403@linux.intel.com>
  <200702070049.51536.donner@dbd-breitband.de> <45C96AC1.4030301@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007, Arjan van de Ven wrote:

> 
> Marc Donner wrote:
>> 501:     215717     209388     209430     202514   PCI-MSI-edge      eth10
>> 502:        927       1019       1053        888   PCI-MSI-edge      eth11
>
> this is odd, this is not an irq distribution that irqbalance should give you
> 1
>> NMI:        451         39         42         46
>> LOC:     170899     170864     170846     170788
>> ERR:          0
>> 
>> top output:
>> 
>> top - 01:45:32 up 16 min,  2 users,  load average: 1.04, 0.92, 0.50
>> Tasks:  81 total,   3 running,  78 sleeping,   0 stopped,   0 zombie
>> Cpu0  :  0.0% us,  0.0% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi, 100.0% 
>> si
>> 
> and this doesn't match the irq output...
> sounds as if something has a real bug; can you send an lsmod ? maybe some 
> driver keeps doing si's

since this only happens when he adds more iptables rules, is it possible that 
there sis some locking, or otherdata structure access that's serializing things 
under load?

Marc, since you don't use modules, send your .config.

David Lang
