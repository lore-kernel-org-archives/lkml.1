Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbZDEOnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbZDEOnb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 10:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZDEOnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 10:43:23 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:63614 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbZDEOnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 10:43:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KDeS97Wb+7yLZSQHfeQv7wb+27xp+PPx4cB5KQyCyq9POLfKHoxEzqljkr61fiMr+9
         4DJuu6Ic1dS7nPyfo0TEjbccqeULxOr+elmXaJW64rSahqNI1jb8v70xqysLwG7afhTw
         74Oyetyjdg7yEyV6KTfGJMo8jJKqBONONY8vk=
MIME-Version: 1.0
In-Reply-To: <49D8ABA8.20700@redhat.com>
References: <COL116-W68F0521CACD2E1656E8D1BDA870@phx.gbl>
	 <49D8ABA8.20700@redhat.com>
Date: Sun, 5 Apr 2009 10:43:20 -0400
X-Google-Sender-Auth: faa5f87aee3dc389
Message-ID: <b6c5339f0904050743k799104f1x443edb69a00fdb64@mail.gmail.com>
Subject: Re: Intepreting an oops
From: Bob Copeland <me@bobcopeland.com>
To: Peter Hallberg <hallberg68@hotmail.com>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 5, 2009 at 9:01 AM, Avi Kivity <avi@redhat.com> wrote:
> Peter Hallberg wrote:
>>
>> How does one translate the offset in the function to a line number in the
>> source code?
>> [  218.418473] Call Trace:
>> [  218.418484]  [] :nnpfs:nnpfs_writepage+0xab/0x230
>>
>
> You can use 'objdump -Sr nnpfs.ko' and look for the address of
> nnpfs_writepage, plus 0xab.

I use the above sometimes, also you can do:

gdb nnpfs.ko
gdb> l *(nnpfs_writepage+0xab)

Documentation/oops-tracing.txt has some helpful tips.

-- 
Bob Copeland %% www.bobcopeland.com
