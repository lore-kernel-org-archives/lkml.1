Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbYHSJvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbYHSJvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbYHSJvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:51:04 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:50351 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbYHSJvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:51:03 -0400
Message-ID: <48AA9757.3090002@csr.com>
Date: Tue, 19 Aug 2008 10:50:15 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net, jeffrey.t.kirsher@intel.com,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
References: <489C2457.5030104@csr.com> <20080818224011.6fad74dc.akpm@linux-foundation.org>
In-Reply-To: <20080818224011.6fad74dc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Aug 2008 09:50:15.0805 (UTC) FILETIME=[FB59FAD0:01C901E0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 08 Aug 2008 11:47:51 +0100 David Vrabel <david.vrabel@csr.com> wrote:
> 
>> 2.6.27-rc1 kernels appear to corrupt the EEPROM/NVM of the 8086:294c
>> ethernet device (ICH9 I think).  After hacking the driver to ignore the
>> bad CRC and MAC address I could view the EEPROM with ethtool and it was
>> all 0xff.
>>
>> Testing EEPROM reads and writes with ethtool appeared to work but after
>> a reboot of the system the ethernet device (see lspci -v output) was no
>> longer present.  Could invalid EEPROM contents with a valid CRC (as
>> would be the case after my read/write tests) result in the device
>> failing to enumerate on the PCIe bus?

FYI, Jesse Brandeburg replied off-list and said that a corrupt EEPROM
with a valid CRC can result in the device failing to enumerate.

> Is this still happening in Linus's current tree?

I don't know, and I'm reluctant to try until I have a reliable way to
restore an erased EEPROM.

> Was 2.6.26 OK?

2.6.26 was fine.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
