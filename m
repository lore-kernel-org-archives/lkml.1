Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871Ab0ASRmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab0ASRmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628Ab0ASRmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:42:16 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45139 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab0ASRmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:42:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=B1vJsGSD+zZ7HUtZ8IGZqso4pCWOql09RSXHHIhcq2v4r/0fySFygX54HAK1qpHqoy
         w13lLVDMLAVSwMmQA0iy0VmA2EkT5bzkYfZ8FONmBgmhxOUWZUMrN4bA2ZZEUetMJmIL
         sEyWy+t7pKWhX+zcmqDk8B6jQWAltr+PkxEQQ=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a1001190923p6104acb4if5ec7225d549b713@mail.gmail.com>
References: <1263883920-17289-1-git-send-email-vapier@gentoo.org>
	 <20100119142545.GB3473@hack>
	 <8bd0f97a1001190923p6104acb4if5ec7225d549b713@mail.gmail.com>
Date: Tue, 19 Jan 2010 18:42:13 +0100
X-Google-Sender-Auth: ece7d943d2056ad8
Message-ID: <520f0cf11001190942n2c765618m8a66b8afe82010d0@mail.gmail.com>
Subject: Re: [PATCH] kconfig: dont hardcode path to lsmod
From: John Kacur <jkacur@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 6:23 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Tue, Jan 19, 2010 at 09:25, Américo Wang wrote:
>> On Tue, Jan 19, 2010 at 01:52:00AM -0500, Mike Frysinger wrote:
>>>The lsmod utility has always been installed into /bin with the newer
>>>module-init-tools package, so let lsmod be found via PATH instead of
>>>hardcoding the old modutils /sbin path.
>>>
>>
>> Some distro doesn't set /sbin to PATH, so for me a better solution
>> would be making PATH contain /sbin, and then use "lsmod".
>
> read my changelog -- module-init-tools has always installed into /bin.
>  so what your distro does with /sbin doesnt matter.
> -mike
> --

I prefer my patches work for the real-world instead of the "so what
your distro does doesn't matter" world.
