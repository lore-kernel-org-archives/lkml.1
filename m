Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbZFYKpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbZFYKpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759371AbZFYKoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:44:54 -0400
Received: from mail-pz0-f189.google.com ([209.85.222.189]:34057 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759552AbZFYKox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:44:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NISjlhlM9t/nLAdayFuQ9KWxz6cBH1YGuAeH+IWYYgmBn1ZpINJMo/7nZUOXvT5Y/k
         s/wSQgh535Mh6n2VYbW6GtkmeXJukmbWk3QC3eFBrx4ZiEntntH9RrTeeskRdWuRimyM
         aKKrwMo5/1HbixlIT2hB6j38GG67qhzcmPq54=
Date: Thu, 25 Jun 2009 18:47:00 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, Paul Menage <menage@google.com>,
       akpm@linux-foundation.org, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [PATCH] UML: Fix some apparent bitrot
Message-ID: <20090625104700.GF6374@cr0.nay.redhat.com>
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com> <20090622024610.GC5893@cr0.nay.redhat.com> <4A421AA6.5060908@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A421AA6.5060908@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Jun 24, 2009 at 03:23:02PM +0300, Boaz Harrosh wrote:
>On 06/22/2009 05:46 AM, Amerigo Wang wrote:
>> On Fri, Jun 19, 2009 at 05:55:24PM -0700, Paul Menage wrote:
>>> UML: Fix some apparent bitrot
>>>
>>> - migration of net_device methods into net_device_ops
>>> - dma_sync_single() changes
>>> - cpumask_clear() -> cpumask_clear_cpu()
>>>
>>> Signed-off-by: Paul Menage <menage@google.com>
>> 
>> 
>> Looks good.
>> 
>> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>> 
>> 
>
>Dear Jeff, Amerigo
>
>who is pushing this patch to Linus for 2.6.31. (ASAP)
>Linus has threatened to cut -rc1 soon, and it is
>unbuildable for UML currently.

Hello, Boaz.

It is supposed to be Jeff who should take UML patches,
but since we haven't seen Jeff for a long time, Andrew
should help us to take them.

So Andrew? ping... :)
