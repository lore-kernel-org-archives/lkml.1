Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbYBGN0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbYBGN0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 08:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbYBGN0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 08:26:21 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34811 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbYBGN0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 08:26:20 -0500
Message-ID: <47AB06F9.30201@davidnewall.com>
Date: Thu, 07 Feb 2008 23:56:17 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Chris Friesen <cfriesen@nortel.com>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
References: <20080125180232.GA4613@kroah.com> <20080202123710.42df1aa0@weinigel.se> <20080202191930.GA19826@kroah.com> <20080203124849.0226560f@weinigel.se> <84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com> <47A5F418.6030104@weinigel.se> <20080203231530.GB15692@kroah.com> <courier.47A8EDDC.0000785F@hawking.rebel.net.au> <47A8F27F.3060504@nortel.com> <20080206210452.GB7198@cs181133002.pp.htv.fi>
In-Reply-To: <20080206210452.GB7198@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Feb 05, 2008 at 05:34:23PM -0600, Chris Friesen wrote:
>   
>> David Newall wrote:
>>     
>>> That being said, a module can be written such that it only dynamically 
>>> links with the kernel.  Ndiswrapper is an example of how this can be 
>>> done: None of the drivers that work under ndiswrapper make any direct 
>>> use of the kernel, not in any way, indeed a wrapper could be written 
>>> for a different operating system.
>>>       
>> The issue is all about "derivative works" in copyright law.
>>
>> Ndiswrapper is in a good position because the closed-source drivers were  
>> originally written for another OS so it's pretty well impossible to  
>> argue that they are derived from linux.
>> ...
>>     
>
> IANAL, but when looking at the "But when you distribute the same 
> sections as part of a whole which is a work based on the Program, the 
> distribution of the whole must be on the terms of this License" of the 
> GPLv2 I would still consult a lawyer before e.g. selling a laptop with a 
> closed-source driver loaded through ndiswrapper.
>   

Don't ignore, "mere aggregation of another work not based on the Program
with the Program (or with a work based on the Program) on a volume of a
storage or distribution medium does not bring the other work under the
scope of this License."  Static linking certainly makes something part
of the whole; dynamic linking doesn't.
