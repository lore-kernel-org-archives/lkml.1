Return-Path: <linux-kernel-owner+w=401wt.eu-S1758816AbZFZN0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816AbZFZN0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 09:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbZFZN0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 09:26:48 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:44239 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbZFZN0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 09:26:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=H6diS/r62Vcv8dUqh1gtJMr4TOutFm0pj4aq2+sBbCvOzgmLRvhSG+wExyGZ9c0CnD
         N3U+9t44WpVcCkX34Hw+xhJmfTW00C068Q4RonhqASx19m2od0EQsOTNYkfWUjpegt1U
         ST3dLmEwyGh90uejcnjNTS+LOqQcECj/j6Sws=
MIME-Version: 1.0
In-Reply-To: <1158166a0906260100q79475523l546cddde2c0ca03@mail.gmail.com>
References: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com> 
	<20090625091002.0b8203a7@lxorguk.ukuu.org.uk> <1158166a0906260100q79475523l546cddde2c0ca03@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 26 Jun 2009 09:26:30 -0400
Message-ID: <8bd0f97a0906260626y36190ca9ia769c623d4c545d3@mail.gmail.com>
Subject: Re: [PATCH] allow execve'ing "/proc/self/exe" even if /proc is not 
	mounted
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 04:00, Denys Vlasenko wrote:
> On Thu, Jun 25, 2009 at 10:10 AM, Alan Cox wrote:
>>> With this patch, it is possible to execute /proc/self/exe
>>> even if /proc is not mounted. In the below example,
>>> ./sh is a static shell binary:
>>
>> What if the user has procfs mounted somewherelse, what if they are in a
>> chroot where you don't want them to patch the binary and re-exec it ?
>>
>> It would be far far cleaner for NOMMU to have a NOMMU private "reexec()"
>> call that didn't rely on procfs or hacking names into the kernel.
>>
>> So NAK
>
> I am ok with it. Are other people ok with adding a syscall
> just for this purpose? Al?

please try a custom binfmt first
-mike
