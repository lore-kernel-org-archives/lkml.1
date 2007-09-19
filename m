Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbXISLyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbXISLyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbXISLxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:53:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:61794 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbXISLxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=oO2FIJZ3BcwI/HhCFyMHba7lMSVKOAifsbknIlL262MLA+EERP8GP6df56/r7240Mktu8jAy2zSg+EHTGwil13Pj6XgyQsxqF3CEji8Zb7akzfU4INo3vmJ0omk0WoC4YKflzepwiOjlfnK3tX2oTe9Ipcf0cwjzKZqf0UWVnyo=
Message-ID: <46F10DCB.1090302@gmail.com>
Date: Wed, 19 Sep 2007 13:53:47 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com>
In-Reply-To: <46F10B69.5070008@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2007 01:43 PM, Jiri Slaby wrote:
> On 09/18/2007 10:18 AM, Andrew Morton wrote:
>> - The Vaio hangs when quitting X due to x86_64-mm-cpa-clflush.patch, but
>>   I didn't drop that patch because the iommu patch series depends on it.
> 
> No matter whether slub/slab is selected someone gets a page and moves/adds its

Oh, only adds, if it moves, it won't break the list. Going to check for
POISON1/2 in __list_add, will get results (if any) in few moments...

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
