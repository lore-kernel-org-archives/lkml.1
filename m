Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbYJMU44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbYJMU44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbYJMU4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:56:47 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:39148 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbYJMU4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:56:46 -0400
In-Reply-To: <20081013184443.GA20612@ld0162-tx32.am.freescale.net>
References: <20081013040703.GA11059@ime.usp.br> <20081013045116.GA11637@ime.usp.br> <Pine.LNX.4.64.0810132003350.9041@axis700.grange> <20081013184443.GA20612@ld0162-tx32.am.freescale.net>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <66BF36BF-E218-4F2C-BE98-2A84E1E98C0D@ime.usp.br>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: [PATCH] powerpc: enable heap randomization for linkstations
Date: Mon, 13 Oct 2008 18:56:38 -0200
To: Scott Wood <scottwood@freescale.com>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Scott, Guennadi.

On 13/10/2008, at 16:44, Scott Wood wrote:

> On Mon, Oct 13, 2008 at 08:05:09PM +0200, Guennadi Liakhovetski wrote:
>> On Mon, 13 Oct 2008, Rogério Brito wrote:
>>
>>> The current defconfig for Linkstation/Kuroboxes has the "Disable  
>>> Heap
>>> Randomization" option enabled.
>>>
>>> Since some of these machines are facing the internet, it helps to  
>>> have
>>> heap randomization enabled. This patch enables it.
>>
>> Same as the previous patch - this is one of options, that users  
>> select
>> according to their needs. If any specific distribution enables  
>> this option
>> by default in their kernels, they can do this too, don't think  
>> this is
>> critical enough to patch the defconfig.

I think that the matter is not being critical or not, but of  
including a sane default as the kernel should be a place for best- 
current-practices.

> Just because users/distros can change it doesn't mean it's  
> pointless to
> discuss what default is sane, and make changes if the current default
> isn't.

Exactly my point.

> For security-related options it's usually best to default to the more
> secure state, especially since the option description talks about it
> being needed mainly for libc5 compatibility -- did libc5 ever even  
> exist
> for powerpc?

I don't know, but even Debian's very ancient distributions all came  
with libc6 on powerpc.

> The only reason it was turned on in the first place was likely the
> "default y", which in turn is there to avoid breaking old x86 distros.

Exactly. Agreed 100%.


Regards, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org



