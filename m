Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbYE2KAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbYE2KAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 06:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYE2KAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 06:00:38 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40958 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYE2KAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 06:00:37 -0400
Message-ID: <483E7EE0.4050703@bull.net>
Date: Thu, 29 May 2008 12:01:04 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Restore MSGPOOL original value
References: <20080526091716.087875000@bull.net>	<20080526091741.735792000@bull.net> <20080528154823.e7c700bb.akpm@linux-foundation.org>
In-Reply-To: <20080528154823.e7c700bb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 26 May 2008 11:17:17 +0200
> Nadia.Derbey@bull.net wrote:
> 
> 
>>Subject: [PATCH] Restore MSGPOOL original value
> 
> 
> Please prefer to include the subsystem identifier in the patch title.  ie:
> 
> 	[patch] ipc: restore MSGPOOL original value
> 
> It saves me from having to do it ;)

Sorry for that.

> 
> 
>>Date: Mon, 26 May 2008 11:17:17 +0200
>>User-Agent: quilt/0.45-1
>>
>>Hi,
>>
>>When posting:
>>[PATCH 1/8] Scaling msgmni to the amount of lowmem
>>(see http://article.gmane.org/gmane.linux.kernel/637849/), I have changed the
>>MSGPOOL value to make it fit what is said in the man pages (i.e. a size in
>>bytes).
>>
>>But Michael Kerrisk rightly complained that this change could affect the ABI.
>>So I'm posting this patch to make MSGPOOL expressed back in Kbytes.
>>Michael, on his side, has fixed the man page.
>>
>>This patch applies to 2.6.26-rc2-mm1.
> 
> 
> But it is needed in 2.6.26, yes?
> 

Yes.

Regards,
Nadia
