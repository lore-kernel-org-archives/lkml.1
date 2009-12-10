Return-Path: <linux-kernel-owner+w=401wt.eu-S1761754AbZLJVpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761754AbZLJVpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761743AbZLJVpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:45:49 -0500
Received: from claw.goop.org ([74.207.240.146]:58733 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761741AbZLJVps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:45:48 -0500
Message-ID: <4B216C12.1020001@goop.org>
Date: Thu, 10 Dec 2009 13:45:54 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Fedora/3.0-3.12.rc1.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Problems with serial interrupts with IPMI 2.0 SoL
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using a system with an embedded IPMI 2.0 BMC which provides SoL 
(Supermicro X8SIL-F).  This works fine under Linux (fully interrupt 
driven), but fails for Xen as it appears to not be sending interrupts; 
it works OK if I set the driver to polling mode.

I'm assuming the Xen is tickling some bug in the emulated 16550.  The 
Linux driver has a couple of pieces of code to explicitly work around 
bugs in the Intel AMT SoL implementation, but I don't think they're 
coming into play here (because there are no Intel SoL PCI devices on 
this system to trigger the NO_TXEN_TEST flag).

I'm wondering if you have any pointers or suggestions about more subtle 
problems?

Thanks,
     J
