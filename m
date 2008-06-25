Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbYFYOmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbYFYOmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYFYOhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:37:06 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41601 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbYFYOhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:37:03 -0400
Date: Wed, 25 Jun 2008 21:32:34 +0700
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
       varunc@linux.vnet.ibm.com, jbarnes@virtuousgeek.org, greg@kroah.com
Subject: Re: Strange problem with e1000 driver - ping packet loss
Message-ID: <20080625143234.GB3899@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <fa.QBOn2aWyqGnBJJticG4h09lpxD0@ifi.uio.no> <485A9678.5000707@shaw.ca> <20080620123054.GH3548@linux.vnet.ibm.com> <485BC16F.8050409@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485BC16F.8050409@shaw.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 08:40:47AM -0600, Robert Hancock wrote:
> Looks reasonable to me.. and what does /proc/interrupts show with this 
> setup?

Sorry about the delay, but here's /proc/interrupts:

           CPU0       
  0:    1342021    IO-APIC-edge  timer
  1:        416    IO-APIC-edge  i8042
  6:          6    IO-APIC-edge  floppy
  8:          1    IO-APIC-edge  rtc
 12:      13367    IO-APIC-edge  i8042
169:          1   IO-APIC-level  acpi
177:       8882   IO-APIC-level  libata, eth1
185:      75633   IO-APIC-level  uhci_hcd:usb1, i915@pci:0000:00:02.0
193:          0   IO-APIC-level  uhci_hcd:usb2
NMI:          0 
LOC:    1341970 
ERR:          0
MIS:          0



-- 
Regards,
vatsa
