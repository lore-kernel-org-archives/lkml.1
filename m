Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZFZWzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZFZWzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbZFZWzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:55:33 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:41100 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbZFZWzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LwegK1bJtXJFjIhpMe/flwzgkwfZSeK0gZK2Q9MBkt95dDKY/Fw2DAe+z/YHOl06eL
         ZN74Ejd4RsQf0lHmyZtG7ZYeGsN8KIbLn3Cr0e/5xBgwXXAUyyXcdbV84Lhig1UUSeKo
         87JZ8F+BDer9Fy90xvwW6ME8qG9vgo9iC6utQ=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0906260626y36190ca9ia769c623d4c545d3@mail.gmail.com>
References: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com>
	 <20090625091002.0b8203a7@lxorguk.ukuu.org.uk>
	 <1158166a0906260100q79475523l546cddde2c0ca03@mail.gmail.com>
	 <8bd0f97a0906260626y36190ca9ia769c623d4c545d3@mail.gmail.com>
Date: Sat, 27 Jun 2009 00:55:32 +0200
Message-ID: <1158166a0906261555k3f00e9bdi74960e9eb72a4bb7@mail.gmail.com>
Subject: Re: [PATCH] allow execve'ing "/proc/self/exe" even if /proc is not 
	mounted
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 3:26 PM, Mike Frysinger<vapier.adi@gmail.com> wrote:
> On Fri, Jun 26, 2009 at 04:00, Denys Vlasenko wrote:
>> On Thu, Jun 25, 2009 at 10:10 AM, Alan Cox wrote:
>>>> With this patch, it is possible to execute /proc/self/exe
>>>> even if /proc is not mounted. In the below example,
>>>> ./sh is a static shell binary:
>>>
>>> What if the user has procfs mounted somewherelse, what if they are in a
>>> chroot where you don't want them to patch the binary and re-exec it ?
>>>
>>> It would be far far cleaner for NOMMU to have a NOMMU private "reexec()"
>>> call that didn't rely on procfs or hacking names into the kernel.
>>>
>>> So NAK
>>
>> I am ok with it. Are other people ok with adding a syscall
>> just for this purpose? Al?
>
> please try a custom binfmt first

I did not understand you.
--
vda
