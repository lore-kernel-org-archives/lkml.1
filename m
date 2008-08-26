Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbYHZQVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbYHZQVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYHZQU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:20:56 -0400
Received: from smtp4.tech.numericable.fr ([82.216.111.40]:44338 "EHLO
	smtp4.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbYHZQUz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:20:55 -0400
Message-ID: <48B42D60.2030405@numericable.fr>
Date: Tue, 26 Aug 2008 18:20:48 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008082610)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Greg KH <gregkh@suse.de>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.27-rc4-git4] compilation warnings
References: <48B3CEEA.90400@numericable.fr> <20080826152034.GA6593@suse.de> <200808260908.07982.jbarnes@virtuousgeek.org>
In-Reply-To: <200808260908.07982.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Tuesday, August 26, 2008 8:20 am Greg KH wrote:
>    
>> On Tue, Aug 26, 2008 at 11:37:46AM +0200, Rufus&  Azrael wrote:
>>      
>>> Hello all,
>>>
>>> Fresh 2.6.27-rc4-git4 causes these compilation warnings on my amd64 box
>>> with gcc-4.3.1 :
>>>
>>> drivers/pci/search.c: In function ‘pci_get_dev_by_id’:
>>> drivers/pci/search.c:284: attention : passing argument 1 of
>>> ‘pci_dev_put’ discards qualifiers from pointer target type
>>>
>>> following this commit : ebca4f1bce1eb7b91a63c515db66316db9391221 PCI: fix
>>> reference leak in pci_get_dev_by_id()
>>>        
>> Ick, sorry about that, I said my fix was not even build tested :)
>>
>> Here's a fix for this, Jesse, care to forward this on?
>>      
>
> Yeah, thanks Greg.  Alex and I built&  booted it, but obviously I missed the
> warning.
>
> Jesse
>
>    
Hello Greg and Jesse,

I have tested this patch which works fine and the warning disappears, 
thanks for all.

Regards.


