Return-Path: <linux-kernel-owner+w=401wt.eu-S1759153AbZHROFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153AbZHROFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbZHROFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:05:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:31453 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbZHROFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:05:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=h+EXVM5KyFYsfcr9ZogN9t04FA2jkoZiT5Mm8F1eDmakkbVqbqnTS1KkPJZ5K2MG8w
         TIgqzJZwpPaMJuUnS13fgd9B4LjScUaizqNvfkiQAzXw/Ltf3D5rLgzB54UdHnH05nK4
         rtfubwDUMOJ/LlhbhvZ73nRvwMyMwQkomM2gg=
Message-ID: <4A8AB525.7050404@gmail.com>
Date: Tue, 18 Aug 2009 22:05:25 +0800
From: Eric Miao <eric.y.miao@gmail.com>
Reply-To: eric.y.miao@gmail.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Eric Miao <eric.y.miao@gmail.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Aric D. Blumer" <aric@sdgsystems.com>,
       Mike Rapoport <mike@compulab.co.il>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: usb/pxa trees build failure
References: <20090818135852.0b3b648d.sfr@canb.auug.org.au> <20090818114242.GA28534@kroah.com>
In-Reply-To: <20090818114242.GA28534@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Aug 18, 2009 at 01:58:52PM +1000, Stephen Rothwell wrote:
>> Hi Eric, Greg,
>>
>> The next-20090817 (and a few before) build (arm trizeps4_defconfig)
>> failed like this:
>>
>> drivers/usb/host/ohci-pxa27x.c:507: error: 'pdev' undeclared (first use in this function)
>>
>> Caused by the interaction of commit
>> 6458baec17e19d38b9d4eb1f96c213f91609c0e3 ("USB: ohci-pxa27x: Reconfigure
>> power settings on resume") from the usb tree with commit
>> b8fb7d4317bcea1b48c9560d23dff81121870ece ("[ARM] pxa: update
>> ohci-pxa27x.c to use 'struct dev_pm_ops'"). from the pxa tree.
>>
>> Greg/Aric, maybe that usb tree patch needs to go through the pxa tree?
>> (and maybe "USB: ohci-pxa27x: Allow NOCP and OCPM to be cleared" as well?)
>>
>> [this also broke the following configs: magician_defconfig,
>> em_x270_defconfig and cm_x2xx_defconfig.]
> 
> Ick, not good.  Aric, should I drop this patch from my tree?
> 

I think so, might be better to go through the pxa tree so that I can give
another review. (the fiber across the pacific seems to be broken again, so
I have to look into this tomorrow, still fetching -next, sigh).
