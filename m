Return-Path: <linux-kernel-owner+w=401wt.eu-S1161595AbXDLLtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161595AbXDLLtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 07:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161601AbXDLLtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 07:49:47 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:53915 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161595AbXDLLtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 07:49:46 -0400
Message-ID: <461E1B41.90000@aitel.hist.no>
Date: Thu, 12 Apr 2007 13:42:57 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
References: <20070408143559.f5014629.akpm@linux-foundation.org> <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org> <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704120947230.12991@twin.jikos.cz> <Pine.LNX.4.64.0704121001400.12991@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0704121001400.12991@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Thu, 12 Apr 2007, Jiri Kosina wrote:
>
>   
>> Could you please
>> - try booting without any HID devices plugged in (i.e. usb mice, usb 
>>   keyboards) if the problem persists?
>> - recompile 2.6.21-rc6-mm1 with git-hid.patch reverted to see if it helps?
>>     
>
> Do you compile with CONFIG_HIDRAW?
>   
No, that one is not set. 

I did use the new SLUB thing - could that possibly be the cause?
Going back to SLAB is easy enough. 

Helge Hafting
