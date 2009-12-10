Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbZLJG7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbZLJG7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 01:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbZLJG72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 01:59:28 -0500
Received: from mail-qy0-f202.google.com ([209.85.221.202]:43199 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbZLJG7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 01:59:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VJVo7n1nTP8F/xAyuBBASgcgtT70hWAesj7ONhTB/Tnpt8lvkWG9/nkPL2xX9babmF
         4b8mEn0BziXWC9j7aLooSdw7Mxby99RGOKnVWCzWiZORLMG5cCaZV/eDSuvLNwm2HR1i
         oB6/w1dLmu0d9tWNe7RjAQzNKS7YL77JGyYgU=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0912091442360.30748@sister.anvils>
References: <2375c9f90912090238u7487019eq2458210aac4b602@mail.gmail.com>
	 <Pine.LNX.4.64.0912091442360.30748@sister.anvils>
Date: Thu, 10 Dec 2009 14:59:28 +0800
Message-ID: <2375c9f90912092259pe86356cvb716232ba7a4d604@mail.gmail.com>
Subject: Re: An mm bug in today's 2.6.32 git tree
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 9, 2009 at 10:49 PM, Hugh Dickins
<hugh.dickins@tiscali.co.uk> wrote:
> On Wed, 9 Dec 2009, Américo Wang wrote:
>
>> Hi, mm experts,
>>
>> I met the following bug in the kernel from today's git tree, accidentally.
>> I don't know how to reproduce it, just saw it twice when doing different
>> work. Machine is x86_64.
>>
>> Is this bug known?
>
> Thanks for the report.  Not known to me.
> It looks like something has corrupted the start of a pagetable.
> No idea what that something might be, but probably not bad RAM.
>
>>
>> Please feel free to let me know if you need more info.
>
> You say you saw it twice: please post what the other occasion
> showed (unless the first six lines were identical to this and it
> occurred around the same time i.e. separate report of the same).
>

Yes, the rest are almost the same, the only difference is the 'addr'
shows different addresses.

The one I reported happened when I exited vim, after editing a file.
The other one happened when I did a network upload, either over
NFS or ftp or something like that.

Thanks.
