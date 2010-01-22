Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039Ab0AVQhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0AVQhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667Ab0AVQhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 11:37:16 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39293 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab0AVQhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 11:37:10 -0500
Message-ID: <4B59D421.2020708@cs.helsinki.fi>
Date: Fri, 22 Jan 2010 18:36:49 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: remove impossible condition
References: <alpine.DEB.2.00.1001151249040.11990@chino.kir.corp.google.com> <alpine.DEB.2.00.1001151736110.10558@router.home>
In-Reply-To: <alpine.DEB.2.00.1001151736110.10558@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 15 Jan 2010, David Rientjes wrote:
> 
>> `s' cannot be NULL if kmalloc_caches is not NULL.
>>
>> This conditional would trigger a NULL pointer on `s', anyway, since it is
>> immediately derefernced if true.
> 
> Ok that was caused by the patches for the dma kmalloc in the -next tree.
> 
> Acked-by: Christoph Lameter <cl@linux-foundation.org>

Applied, thanks!
