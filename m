Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbZBXUyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbZBXUyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 15:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbZBXUyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 15:54:12 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:47549 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbZBXUyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 15:54:10 -0500
Message-ID: <49A45EAF.9090500@oracle.com>
Date: Tue, 24 Feb 2009 12:55:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Rewrite MSI-HOWTO
References: <1235410082-5016-1-git-send-email-matthew@wil.cx> <1235410082-5016-2-git-send-email-matthew@wil.cx> <49A451C3.4000602@oracle.com> <20090224202808.GG25248@linux.intel.com>
In-Reply-To: <20090224202808.GG25248@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49A45E6C.00A1:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> Thanks for the review!
> 
> On Tue, Feb 24, 2009 at 12:00:03PM -0800, Randy Dunlap wrote:
>> Matthew Wilcox wrote:
>>> +A Message Signalled Interrupt is a write from the device to a special
>> Consistent spelling, please.
> 
> Ah yes, I thought I'd fixed that.  I'll follow the PCI spec and use one 'l'.
> 
>>> +To support this, the kernel must call each interrupt handler associated
>>> +with an interrupt which leads to reduced performance for the system as
>>    with an interrupt,
> 
> Ack.
> 
>>> +Device drivers should normally call this function once per device
>>> +during the initialization phase.
>> Consistent isation/ization (or ised/ized), please.
> 
> The Shorter OED is quite amusing on this point.  It lists 'Initialise' as a
> variant, but in the main definition under 'Initialize', the example it
> gives of the computer usage uses 'initialise'.  I can only conclude that
> a foolish consistency is the hobgoblin of little minds ;-)
> 
>>> +4.6 How to tell whether MSI/MSI-X is enabled on a device
>>> +
>>> +Using lspci -v (as root) will show some devices with "Message Signalled
>> Oh gosh, does lspci misspell it?
> 
> It used to.  The good news is that recent pciutils now just use MSI
> instead of spelling it out.  As a bonus, the capability now fits on one
> line.
> 
>>> +Interrupts" and others with "MSI-X".  Each of these capabilities have an
>>                                          Each ..................... has an
> 
> You're correct.
> 
>>> +'Enable' flag which will be followed with either "+" (enabled) or "-"
>>> +(disabled).
> 
> 
>>> +including a full lspci -v so we can add the quirks to the kernel.
>>    I would say      "lspci -v" ...
> 
> Good idea.
> 
>>> +Then, lspci -t gives the list of bridges above a device.  Reading
>>          "lspci -t"
> 
> Likewise.
> 
>>> +It is also worth checking whether the device driver supports MSIs.
>>> +
>> Unneeded ending blank line (nit).
> 
> Heh.  I'll take it out.
> 
> May I add your reviewed-by tag?

Yes.

-- 
~Randy
