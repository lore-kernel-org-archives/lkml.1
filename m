Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbZGCCgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbZGCCgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbZGCCgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:36:09 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:43075 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbZGCCgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:36:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N22miW39hKsSkpkRWsIPIcJBoXKxAIlROLPov/+cPE6/JfsxeBHSBjg5UQMZrkQEyK
         koZcPbGFJk5dUMfX3vsvUEug92M/e424QL8KkqoCwb3pXOKk7K0v/xIvig+G7RlaC2qo
         EMcGbxl+fYn58UYiZ+6x6DLyn3J73SPCk4N9o=
MIME-Version: 1.0
In-Reply-To: <1246561482.27006.10694.camel@localhost.localdomain>
References: <3877989d0906291953n599b7047x5fdf6033114e0eed@mail.gmail.com>
	 <1246561482.27006.10694.camel@localhost.localdomain>
Date: Fri, 3 Jul 2009 10:36:10 +0800
Message-ID: <3877989d0907021936p7489f201t71f080d61ab1236f@mail.gmail.com>
Subject: Re: [RFC patch] disable the assumption of apic_is_clustered_box for 
	cores >= 6
From: Luming Yu <luming.yu@gmail.com>
To: suresh.b.siddha@intel.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 3, 2009 at 3:04 AM, Suresh Siddha<suresh.b.siddha@intel.com> wrote:
> On Mon, 2009-06-29 at 19:53 -0700, Luming Yu wrote:
>> Hello,
>>
>> We have to disable the assumption of apic_is_clustered_box that assumes high
>> 4bits of 8 bit APIC ID was cluster id, which is just the function's guess.
>> On a normal 4-socket system with >6cores Processor and HT enabled, we hit the
>> limitation of the guess and failed. Have to disable the guess on any
>> cores > 6 system.
>>
>> Without this patch, we can't use good TSC on any SMP system with 48+ logical CPU
>
> This patch doesn't seem to be the right fix. BTW, it appears that
> Yinghai's patch in mainline appear to address this issue already. Did
> you check if the mainline still has the issue that you are trying to fix
> here?

Oh.. my testing kernel is still -rc6. The patch should fix the problem.
Thanks for the pointer. I believe I have heard of this patch, but don't know
why I didn't check that first before spending time on this fix,
although this patch didn't take
too much time, but does create some noise. I'm sorry about that.
