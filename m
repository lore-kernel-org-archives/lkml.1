Return-Path: <linux-kernel-owner+w=401wt.eu-S1757625AbYJQRb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbYJQRb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbYJQRbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:31:50 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:51547 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbYJQRbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:31:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=le1BY+6w01a9wh3kn4ms5Xvs8SfYjZpwnNmLGA5LvW/7m1dLfJIxTzeO3+tQAemeqZ
         1ZmuCROiN+ecj1HgejwB56rPkj0ZEmIov6Z7VGiI/71TauawT7XovbH+yfj1a0t1T3fU
         uhc2zb6EA8Ry7b1USvHIjD0GUPERYxC7aViBQ=
Date: Fri, 17 Oct 2008 18:31:23 +0100
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] init: Properly placing noinline keyword.
Message-ID: <20081017173123.GC19832@hack.voiplan.pt>
References: <b9df5fa10810170605t50e366e9nf62f8a18df37fc3c@mail.gmail.com> <20081017141354.GA9242@x200.localdomain> <b9df5fa10810170717p36dcb4a9y4e74089069dea03c@mail.gmail.com> <20081017142610.GA19832@hack.voiplan.pt> <b9df5fa10810170810x4d3e385n3a2284dd8b2600df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b9df5fa10810170810x4d3e385n3a2284dd8b2600df@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 09:10:07PM +0600, Rakib Mullick wrote:
>On 10/17/08, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Fri, Oct 17, 2008 at 08:17:33PM +0600, Rakib Mullick wrote:
>>  >On 10/17/08, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>>  >> On Fri, Oct 17, 2008 at 07:05:32PM +0600, Rakib Mullick wrote:
>>  >>  > Here, noinline keyword should be placed between storage class and type.
>>  >>
>>  >>
>>  >> Why?
>>  >Because, scripts/checkpatch.pl warned with following warning:
>>  >     ERROR: inline keyword should sit between storage class and type
>>
>>
>> Well, 'noinline' is different from 'inline'.
>>
>>  'noinline' is defined as:
>>
>>  #define  noinline                       __attribute__((noinline))
>>
>>  in include/linux/compiler-gcc.h. But 'inline' is a _keyword_ defined
>>  by C standard. If checkpatch.pl complains about 'noinline', you should
>>  fix checkpatch.pl. :)
>Thanks, for explanation. But isn't it nice to place it between storage
>class and type ?

I don't think so, I don't know why checkpatch.pl prefers that style.
I think probably only because that is more readable?

Anyway, gcc attribute is another different thing.

-- 
"Sometimes the only way to stay sane is to go a little crazy."

