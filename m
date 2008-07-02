Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbYGBOrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbYGBOrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYGBOrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:47:40 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:46907 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbYGBOrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:47:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=kcMlaNTGA316ytXCwbwK4aiORqZ86+NYWsheRNF7EUhrkromet6ZI13ECRNvPQxPgx
         t0AmtcFTT2YzuKPle/xmn/+ul05FOEc2mWSk+9PxYvNmr1wmhDy65ehZ/L4eJcz9ejva
         V24ViF/du3sYJP/TRtpXfK1xa1HLptKaSKlJ4=
Message-ID: <486B9504.8080506@gmail.com>
Date: Wed, 02 Jul 2008 17:47:32 +0300
From: Ruksen INANIR <rukseninanir@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: High Memory problem on 2.4.22 Linux, 2GB ppc card
References: <4869EC40.8070105@gmail.com>
In-Reply-To: <4869EC40.8070105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I want to change the MAX_LOW_MEM to 1520 MB, what other settings do i 
need to change?  I do not want to use HIGHMEM because the Fiber channel 
does not support highmem. The card is 2 GB ppc. 1520 MB is enough. At 
the moment card works with 1456 MB MAX_LOW_MEM. but setting the value 
MAX_LOW_MEM to 1520 results problems. I believe there should be other 
settings.

Thanks


Ruksen INANIR wrote:
>
> Hi all,
> I am working on a PPC Motorola card, which runs Linux 2.4.22.  The 
> card has 2 GB onboard memory. But with use 1456 MB of  the available 
> memory.  To increase the memory capacity i  need  to  increase the 
> used memory at least 64 MB. With CONFIG_HIGHMEM option all of the 2 GB 
> memory can be used but, but the fc driver on the card has no high 
> memory support, so this caused problems.
>  Then i saw that the memory is limited to 1456 by
> #define MAX_LOW_MEM        0x5B000000  setting in pgtable.c.  I tried 
> to increase it by 64 MB but i could only increase the value of 
> MAX_LOW_MEM by 47 MB (1503 MB) without CONFIG_HIGHMEM option.
>
> 1)Is there any other setting that i should set other than     
> MAX_LOW_MEM to increase the usable memory to 1520 ? Do i need  to 
> change  TASK_SIZE or KERNEL_START?
> 2)I knew that the addressable physical memory without high memory 
> option was 1 G.  How was it possible to address 1503 MB without 
> CONFIG_HIGHMEM ? What is the max usable memory for 2.4.22 kernel?
>
> Thanks,
> Rinanir.

