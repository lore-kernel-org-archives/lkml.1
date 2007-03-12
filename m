Return-Path: <linux-kernel-owner+w=401wt.eu-S1030656AbXCLQuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030656AbXCLQuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030657AbXCLQuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:50:12 -0400
Received: from phpmyadmin.profiwh.com ([85.93.165.67]:53943 "EHLO
	cacti.profiwh.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030656AbXCLQuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:50:10 -0400
Message-ID: <45F584CB.3050800@gmail.com>
Date: Mon, 12 Mar 2007 17:50:19 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: rmmod uhci_hcd -> BUG: atomic counter underflow
References: <Pine.LNX.4.44L0.0703121223150.2489-100000@iolanthe.rowland.org> <45F58004.3070001@gmail.com>
In-Reply-To: <45F58004.3070001@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby napsal(a):
> Alan Stern napsal(a):
>> On Mon, 12 Mar 2007, Jiri Slaby wrote:
>>> After rmmoding of uhci_hcd on fresh booted 2.6.21-rc3-mm2 I got this:
>>>
>>> BUG: atomic counter underflow at:
> [...]
>>>   [<c01db754>] kobject_put+0x14/0x16
>>>   [<c01db8a3>] kobject_unregister+0x22/0x25
>>>   [<c024c987>] bus_remove_driver+0x75/0x82
>>>   [<c024d3b8>] driver_unregister+0xb/0x18
>>>   [<c01e7020>] pci_unregister_driver+0x13/0x73
>>>   [<f88dbbd9>] uhci_hcd_cleanup+0xd/0x2d [uhci_hcd]
> [...]
>> Would it be possible for you to add the atomic counter underflow check 
>> to 2.6.21-rc3 and see if the problem still occurs?  If it doesn't, 
>> that's a good indication the USB stack isn't guilty -- the bus 
>> registration code hasn't changed for several kernel releases.
> 
> Yes.

I can confirm, that this issue went upstream and is currently present there.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
