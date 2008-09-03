Return-Path: <linux-kernel-owner+w=401wt.eu-S1756426AbYICPE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbYICPE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 11:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbYICPEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 11:04:49 -0400
Received: from dbservice.com ([213.239.204.14]:48830 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754030AbYICPEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 11:04:47 -0400
Message-ID: <48BEA77A.5050104@dbservice.com>
Date: Wed, 03 Sep 2008 17:04:26 +0200
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080731)
MIME-Version: 1.0
To: Steven King <sfking@fdwdc.com>, Tomas Carnecky <tom@dbservice.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
Subject: Re: 2.6.26.[1-3] + x61 tablet + x6ultrabase: no resume	after?undocking
References: <200808301535.22419.sfking@fdwdc.com> <20080901112816.GA21970@khazad-dum.debian.net> <48BBDD2C.5020804@dbservice.com> <200809011205.05253.sfking@fdwdc.com> <20080903144541.GA10978@homac>
In-Reply-To: <20080903144541.GA10978@homac>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-MailScanner-ID: 27F6C20BB3CA.8147C
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0.1, required 5, RDNS_DYNAMIC 0.10)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Holger Macht wrote:
> On Mon 01. Sep - 12:05:04, Steven King wrote:
>> On Monday 01 September 2008 5:16:44 Tomas Carnecky wrote:
>>
>>> I just tested suspend/resume with the CDROM drive removed (an empty
>>> bay). Suspend/resume now works just fine, regardless how I dock/undock
>>> the laptop.
>> I'm seeing the exact same things as Tom.  Also, in my dmesg I see:
>>
>> ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
>> ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Adding notify handler
>> ACPI: Error installing bay notify handler
>>
>> is this significant?
> 
> No, it's not. Bay driver is obsolete with 2.6.26's libata hotplug code.
> 

I don't know whether I should ROFL or be sad, but: In the 2.6.26 stable
tree the bay driver (ACPI_BAY) is marked as EXPERIMENTAL, and now you're
saying that it's obsolete. Do features go right from experimental to
obsolete now?

I'll try to disable the bay driver, let's see if that helps any.

tom
