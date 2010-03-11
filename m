Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0CKCm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 21:42:28 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:44641 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab0CKCm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 21:42:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wAvsWsK/tC3+gCGVfhYFEp0cGKfGsUBWPKBnqxGq7MpMMvpGjm54ND6TTVKCDvlGVH
         5yg7ewDIA2dqU/YZm3wL+ZfqZ4M7o92MOFivw+TYE1sLvgHGGbUYFsCDuOetvHQYho7m
         wjiHAR3hOhILCYclHV1g4qp2W8gUeD5taH1cA=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1003100832200.17615@router.home>
References: <2375c9f91003100029q7d64bbf7xce15eee97f7e2190@mail.gmail.com>
	 <4B977282.40505@cs.helsinki.fi>
	 <alpine.DEB.2.00.1003100832200.17615@router.home>
Date: Thu, 11 Mar 2010 10:42:25 +0800
Message-ID: <2375c9f91003101842g713bba07v146a53f12a15a8d7@mail.gmail.com>
Subject: Re: 2.6.34-rc1: kernel BUG at mm/slab.c:2989!
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       roland@redhat.com, peterz@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 10:33 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Wed, 10 Mar 2010, Pekka Enberg wrote:
>
>> > Please let me know if you need more info.
>>
>> Looks like regular SLAB corruption bug to me. Can you trigget it with SLUB?
>
> Run SLUB with CONFIG_SLUB_DEBUG_ON or specify slub_debug on the kernel
> command line to have all allocations checked.
>
>

Ok, I will try it today.
