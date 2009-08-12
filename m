Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbZHLJ4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbZHLJ4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZHLJ4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:56:23 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:48515 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbZHLJ4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:56:23 -0400
Message-ID: <4A8291F5.8060406@gefanuc.com>
Date: Wed, 12 Aug 2009 10:57:09 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 2/5] Staging: vme: add VME userspace driver
References: <20090809121715.GA3884@braap.org> <4A801D04.6050102@gefanuc.com> <20090810152606.GA23319@braap.org> <4A804B0B.5020809@gefanuc.com> <20090810203637.GD3055@braap.org> <4A8133ED.6070304@gefanuc.com> <20090811094025.GC3251@braap.org> <4A81683D.2030408@gefanuc.com> <20090811210146.GB9910@braap.org> <4A827A84.3060906@gefanuc.com> <20090812093949.GB2604@braap.org>
In-Reply-To: <20090812093949.GB2604@braap.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emilio G. Cota wrote:
> Martyn Welch wrote:
>   
>> Also, it seems that your API doesn't currently support Location
>> Monitors. These are specified in the VME spec, I'd be interested in
>> how
>> you plan to support this feature in a consistent manner with your
>> current API
>>     
>
> What I intend to provide is a sane environment to work with VME
> devices. The first step is to cover the needs of most use cases:
>
> - 1 master Single Board Computer (SBC) running Linux
> - All the other slots have slave devices in them. These devices
>   are controlled by kernel drivers on the SBC.
> - The SBC does DMA, direct I/O access (mapping) to/from the
>   slaves, and handles interrupts from the devices.
>
> Once that's settled we could discuss about further parts of the
> spec. But really today getting the above right is _much_ more
> important than location monitors support.
>   
Right - this is a specific case that you see as important. Depending on 
the number of slots in the rack and the diversity of the cards used, the 
VME core and driver I have suggested already covers this.

However, I also need to consider other cases, such as communications 
between multiple SBCs and potentially a few slave devices. I have a need 
for this *now*, not in the future. To me, slave support and to a lesser 
degree location monitor support is important now, hence why it's 
supported in my driver and core. Hence why I am asking, how do you 
propose to support these features?

Martyn
> E.
>   


-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
