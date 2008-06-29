Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbYF2N3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbYF2N3z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 09:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbYF2N3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 09:29:46 -0400
Received: from il.qumranet.com ([212.179.150.194]:34800 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbYF2N3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 09:29:45 -0400
Message-ID: <48678E48.8010809@qumranet.com>
Date: Sun, 29 Jun 2008 16:29:44 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Agner Fog <agner@agner.org>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
References: <48626514.2040905@agner.org> <20080625092224.736c2541@infradead.org> <4862ECAB.1040402@zytor.com> <4864CFA5.9050901@agner.org> <20080627072231.7337ba18@infradead.org> <4865F0DA.2050906@agner.org> <87myl5pyqo.fsf@basil.nowhere.org> <4866541F.1060709@agner.org> <20080628200231.GA21259@one.firstfloor.org> <48677313.8000804@qumranet.com> <48677E39.6000001@firstfloor.org> <486780BA.6010202@qumranet.com> <486788F4.5060202@firstfloor.org> <48678BBF.80707@qumranet.com> <48678CC5.5080504@firstfloor.org>
In-Reply-To: <48678CC5.5080504@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

  

>> If you use xsave, I don't see how this is different to the user fpu save
>> area.
>>     
>
> For once there's no clear error handling path for allocation failures
> on the (arbitarily sized) xsave state. On user code that can be barely
> tolerated, but for the kernel it would be deadly.
>   

if (kernel_fpu_begin() < 0)
     goto no_sse;

The question is not if it can be done or not, it's whether making raid 
preemptible is worthwhile, and whether we see/want more sse/avx 
accelerated drivers or not.

-- 
error compiling committee.c: too many arguments to function

