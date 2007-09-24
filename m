Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbXIXLyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbXIXLyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 07:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbXIXLyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 07:54:14 -0400
Received: from frosty.hhs.nl ([145.52.2.15]:53152 "EHLO frosty.hhs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289AbXIXLyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 07:54:13 -0400
Message-ID: <46F7A1CF.4010509@hhs.nl>
Date: Mon, 24 Sep 2007 13:38:55 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Jiri Kosina <jikos@jikos.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: USB autosuspend and turning of usb pendrive leds
References: <46F3C704.5000203@hhs.nl> <46F3D326.6050804@hhs.nl> <Pine.LNX.4.64.0709211715250.22331@twin.jikos.cz> <200709241236.37406.oliver@neukum.org>
In-Reply-To: <200709241236.37406.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.2/RELEASE, bases: 24092007 #397111, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Freitag 21 September 2007 schrieb Jiri Kosina:
>> On Fri, 21 Sep 2007, Hans de Goede wrote:
>>
>>> Thats not what I had in mind, autosuspend doesn't work (presumably 
>>> because hal keeps polling for media change) maybe I should fix hal to 
>>> not keep polling for devices which don't have removable media?
>> Hi Hans,
>>
>> I think the correct solution is that HAL stops polling the device as soon 
>> as it sees that it got autosuspended.
> 
> And how would we notice a medium change then? If there's an alternative
> way to notice it or we know it cannot happen there's no reason to poll at all.
> 

It looks like hal is currently polling device of which it knows the medium is 
not removable, like USB-pens.

Regards,

Hans

