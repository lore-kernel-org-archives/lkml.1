Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbYKNA1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbYKNA1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYKNA1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:27:24 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:24450 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYKNA1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:27:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=L5UYEbuKhY5dQHx5kWHBOBcVF4dp8qI99JIpUCobV3FUAkJXG1jsD2z6gTNkvYDZmC
         1MsoGPr1OPmtV9M1haFx6sILfR7qf3Nei54HjhWVUhe+pyad1TV7yH8s6eY9D8+oWyoF
         MT3UTv999QmPFizV9TaZ+JXqI3Mvi12m+jNbQ=
Message-ID: <3aaafc130811131627l52fcb3a0jba5cc566844fc89e@mail.gmail.com>
Date: Thu, 13 Nov 2008 19:27:22 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: Unix sockets via TCP on localhost: is TCP slower?
Cc: olafvdspek@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20081113.162233.39564490.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>
	 <3aaafc130811131619w3ba48a86u6c6e2af35f149bf1@mail.gmail.com>
	 <20081113.162233.39564490.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 7:22 PM, David Miller <davem@davemloft.net> wrote:
> From: "J.R. Mauro" <jrm8005@gmail.com>
> Date: Thu, 13 Nov 2008 19:19:36 -0500
>
>> On Wed, Nov 12, 2008 at 6:20 PM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
>> > Hi,
>> >
>> > Quite often in discussions, I see people claiming Unix sockets are
>> > faster then TCP sockets on a connection that stays inside localhost.
>>
>> Unix domain sockets should be faster because they're not subject to
>> windowing, ACKs, flow control, encapsulation, etc. etc.
>
> And the wakeup rate is higher for TCP, and our process scheduler has
> been getting gradually slower and slower over time since 2.6.22
>

I'm not sure about this, but I now also remember reading somewhere
that TCP has an extra context switch, but I don't know if what I read
was about Linux or a totally different OS.
