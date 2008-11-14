Return-Path: <linux-kernel-owner+w=401wt.eu-S1752013AbYKNIv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbYKNIv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 03:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbYKNIvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 03:51:47 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:36812 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbYKNIvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 03:51:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BtgADfDUFk32jprQWzDZFmj5XnzCOpRvZyl90EjdB4gcvJuqEQU44Ko/bfmwYbmzTS
         HJSYc5VngIoCYsX80pvVhS4f8Q6dPktVi1K2YDPG+TS1nrjbU9E5yRlEDZ/vLYaoJfle
         QKYafd116NDX7QNirMcp9uIArf5tADtUXrdN4=
Message-ID: <b2cc26e40811140051n4e821fddsc5504eedcccc9cdc@mail.gmail.com>
Date: Fri, 14 Nov 2008 09:51:44 +0100
From: "Olaf van der Spek" <olafvdspek@gmail.com>
To: "J.R. Mauro" <jrm8005@gmail.com>
Subject: Re: Unix sockets via TCP on localhost: is TCP slower?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <3aaafc130811131619w3ba48a86u6c6e2af35f149bf1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>
	 <3aaafc130811131619w3ba48a86u6c6e2af35f149bf1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 1:19 AM, J.R. Mauro <jrm8005@gmail.com> wrote:
> On Wed, Nov 12, 2008 at 6:20 PM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
>> Hi,
>>
>> Quite often in discussions, I see people claiming Unix sockets are
>> faster then TCP sockets on a connection that stays inside localhost.
>
> Unix domain sockets should be faster because they're not subject to
> windowing, ACKs, flow control, encapsulation, etc. etc.

Why would you use windowing, ACKs, flow control and encapsulation on localhost?

I expected the kernel to copy data directly from user-space of the
sending process to a kernel buffer of the receiving process, much like
UNIX sockets.

>> Let's say from app A to app B.
>> Is this indeed the case and if so, how much and why?
>> My assumption is that the kernel can optimize the 'connection' and let
>> any performance differences disappear.
>>
>> Greetings,
>>
>> Olaf
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
