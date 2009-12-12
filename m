Return-Path: <linux-kernel-owner+w=401wt.eu-S1763023AbZLLCPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763023AbZLLCPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 21:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762969AbZLLCPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 21:15:25 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:62445 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762926AbZLLCPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 21:15:25 -0500
MIME-Version: 1.0
In-Reply-To: <20091211080254.GB7625@linux-sh.org>
References: <Pine.LNX.4.64.0912101826010.4487@axis700.grange> 
	<Pine.LNX.4.64.0912101833170.4487@axis700.grange> <20091211080254.GB7625@linux-sh.org>
From: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Date: Sat, 12 Dec 2009 11:15:10 +0900
Message-ID: <29ab51dc0912111815s2095539cjc3d0450435725452@mail.gmail.com>
Subject: Re: [PATCH 2/3 v2] sh: fix DMA driver's descriptor chaining and 
	cookie assignment
To: Paul Mundt <lethal@linux-sh.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
       linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Oh, I was going to check an old patch.

2009/12/11 Paul Mundt <lethal@linux-sh.org>:
> On Thu, Dec 10, 2009 at 06:35:11PM +0100, Guennadi Liakhovetski wrote:
>> The SH DMA driver wrongly assigns negative cookies to transfer descriptors,
>> also, its chaining of partial descriptors is broken. The latter problem is
>> usually invisible, because maximum transfer size per chunk is 16M, but if you
>> artificially set this limit lower, the driver fails. Since cookies are also
>> used in chunk management, both these problems are fixed in one patch. As side
>> effects a possible memory leak, when descriptors are prepared, but not
>> submitted, and multiple races have also been fixed.
>>
>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>
> Looks good to me.
Me too.

But I want to check other CPU of sh. I will do next week.
Please wait "Acked-by".

>
> Acked-by: Paul Mundt <lethal@linux-sh.org>

Best regards,
  Nobuhiro

> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Nobuhiro Iwamatsu
   iwamatsu at {nigauri.org / debian.org}
   GPG ID: 40AD1FA6
