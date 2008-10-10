Return-Path: <linux-kernel-owner+w=401wt.eu-S1763596AbYJJUXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763596AbYJJUXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761345AbYJJUXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:23:12 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42884 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761170AbYJJUXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:23:11 -0400
Message-ID: <48EFB99F.3080003@canonical.com>
Date: Fri, 10 Oct 2008 16:22:55 -0400
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: stable@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [stable] [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in	used_vectors
 bitmap
References: <48EFB4B2.2020508@canonical.com> <20081010201639.GB32164@kroah.com>
In-Reply-To: <20081010201639.GB32164@kroah.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Oct 10, 2008 at 04:01:54PM -0400, Stefan Bader wrote:
>> Affected: 2.6.24-2.6.27
>>
>> Someone from the community found out, that after repeatedly unloading and
>> loading a device driver that uses MSI IRQs, the system eventually assigned
>> the vector initially reserved for IRQ0 to the device driver.
> 
> "Someone"?  do you have a name or pointer to the person/bugreport so
> that they can be properly credited?
> 
I had a name in but the person did not want to be mentioned.

> thanks,
>



> greg k-h


-- 

When all other means of communication fail, try words!


