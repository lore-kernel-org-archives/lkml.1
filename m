Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbXJZOlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbXJZOlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 10:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbXJZOlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 10:41:07 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:45199 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbXJZOlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:41:05 -0400
Message-ID: <4721FC6B.8010006@freescale.com>
Date: Fri, 26 Oct 2007 09:40:43 -0500
From: Jon Loeliger <jdl@freescale.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Robin Getz <rgetz@blackfin.uclinux.org>, paulus@samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: history of extratext sections?
References: <200710240836.13412.rgetz@blackfin.uclinux.org>	 <200710260557.32641.rgetz@blackfin.uclinux.org> <1193409099.16168.31.camel@shinybook.infradead.org>
In-Reply-To: <1193409099.16168.31.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Fri, 2007-10-26 at 05:57 -0400, Robin Getz wrote:
>> Is this section still used on PPC, or can the entire support for
>> extratext be removed?
> 
> I think it can die.
> 

Agreed.   For history, see this:

http://ozlabs.org/pipermail/linuxppc-dev/2005-September/019734.html

and

http://ozlabs.org/pipermail/linuxppc-dev/2005-September/019736.html

where Arnd says:

> The users of the ppc64 function in_kernel_text() can probably be converted
> to the generic is_kernel_text() function.
> 
> 	Arnd <><

and

http://ozlabs.org/pipermail/linuxppc-dev/2005-September/019751.html

Where Paul said:

>> And I assume that the obvious mappings can take place (ie, that
>> "pmac.text" can just be placed in regular .text, etc), right?
> 
> Yes.
> 
> Paul.

HTH,
jdl

