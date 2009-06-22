Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbZFVGXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbZFVGXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 02:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZFVGXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 02:23:38 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:33079 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbZFVGXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 02:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pf/qouePG/knk/Me8l1KAr7a+SVKn16CEL5B7tooLI70/EAscgi8zw3XQSWE5t8SeN
         +hekCB5IwF0i7QrWp2Vvkv6vqWENUDOI5FkG2MpA7khok5dq9lLn7EGnXp1wLGE35lyJ
         +sSC1FqJ7/rp+Hg8NJf1SsDyqp9P6s/IUJEn0=
MIME-Version: 1.0
In-Reply-To: <200906212222.25434.arnd@arndb.de>
References: <4A33A7EC.6070008@gmail.com> <200906140059.57362.arnd@arndb.de>
	 <4A3E68CD.6080803@gmail.com> <200906212222.25434.arnd@arndb.de>
Date: Mon, 22 Jun 2009 08:23:38 +0200
Message-ID: <2ea1731b0906212323h6ed8621dg22e1bc8638c26e2c@mail.gmail.com>
Subject: Re: [PATCH 06/14] Pramfs: Include files
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/21 Arnd Bergmann <arnd@arndb.de>:
> On Sunday 21 June 2009, Marco wrote:
>> I was thinking about your comment and I think I'll use __kernel_off_t
>> for the exported headers. I know that it will differ between 32 and 64
>> bit architectures, but for this kind of fs there isn't any compatibility
>> problem at layout level. You cannot remove a chip of RAM from a board
>> 32bit little endian and attach it to a board with a cpu 64bit big
>> endian, the memory isn't a disk. Indeed, I see that tmpfs uses simply
>> "unsigned long" in the exported header file without any problems to
>> little or big endian.
>
> It's still a problem. You might be creating a file system image
> for an embedded board with a different endianess.

It's not possible to create an "image" with pramfs, it's like tmpfs.

> Or even on the same machine, you could be looking at the file system contents
> with a 32 bit process running on a 64 bit kernel.
>
>        Arnd <><
>

Yes, indeed the most important thing is to be sure that a 64bit kernel
works well. I'll try to test it in this environment. If there are
"64bit guys" to help me to test it, it'd be great.

Marco
