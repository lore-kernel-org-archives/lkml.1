Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYAINRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYAINRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 08:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYAINRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 08:17:44 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:63434 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbYAINRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 08:17:40 -0500
Message-ID: <4784C96D.5030805@student.ltu.se>
Date: Wed, 09 Jan 2008 14:17:33 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andre Noll <maan@systemlinux.org>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, paolo.ciarrocchi@gmail.com,
       gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
References: <20080108164015.GC31504@one.firstfloor.org> <20080109103459.GC16462@skl-net.de>
In-Reply-To: <20080109103459.GC16462@skl-net.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andre Noll wrote:
> On 17:40, Andi Kleen wrote:
>  
>   
>> Here's a proposal for some useful code transformations the kernel janitors
>> could do as opposed to running checkpatch.pl.
>>     
>
> Here's my take on drivers/scsi/sg.c. It's only compile-tested on x86-64.
>   
... and x86 with all(yes|mod)config. :)

Would had preferred:

if (x) {
    result = -Exxxx;
    goto out;
}

then:

result = -Exxxx;
if (x)
    goto out;

but it looks correct.

cu,
Richard

