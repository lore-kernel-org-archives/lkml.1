Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbYKNJHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbYKNJHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 04:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYKNJHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 04:07:01 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:26460 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYKNJG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 04:06:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uANai2Firm5XM1/JYxA9jSNdsNMVczonv4mCtbup396mH8FnsuvcuU6pp3N3geiPqO
         9McBBiHw2XiXFLUbDI5kvfx8DAHC0yqCvTXV6XDzxEGxhAlu10wr6gP3tMwfXsvkoj/V
         ReucXYjR0XOfUs51xZo9YLh3WA13PckKOQO2s=
Message-ID: <b2cc26e40811140106n6d43669bn9525754abd1da877@mail.gmail.com>
Date: Fri, 14 Nov 2008 10:06:57 +0100
From: "Olaf van der Spek" <olafvdspek@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: Unix sockets via TCP on localhost: is TCP slower?
Cc: "J.R. Mauro" <jrm8005@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <491D3CD5.5020105@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>
	 <3aaafc130811131619w3ba48a86u6c6e2af35f149bf1@mail.gmail.com>
	 <b2cc26e40811140051n4e821fddsc5504eedcccc9cdc@mail.gmail.com>
	 <491D3CD5.5020105@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 9:54 AM, Eric Dumazet <dada1@cosmosbay.com> wrote:
>> I expected the kernel to copy data directly from user-space of the
>> sending process to a kernel buffer of the receiving process, much like
>> UNIX sockets.
>>
>
> localhost uses a standard network device, and whole network stack
> is used, no 'special kludges'. You can add iptables rules, you
> can do trafic shaping, trafic sniffing (tcpdump), limiting
> memory used by all sockets (controlling memory pressure on the
> machine)
>
> Doing what you suggest would slow down AF_INET stack.

Why?

> You probably can expect AF_UNIX to be faster, since this one is really
> special and use shortcuts.
>
> Then, you probably can use shared memory instead of AF_UNIX, or
> pipes (and splice()), or ...
>
> Then you probably can use threads and do zero-copy ;)

Hmm, I'd like to avoid running my web server inside of my database
server process. ;)
