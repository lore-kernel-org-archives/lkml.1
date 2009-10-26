Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbZJZTmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbZJZTmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbZJZTmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:42:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:60627 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbZJZTmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:42:14 -0400
In-Reply-To: <4AE5F9B9.2010707@s5r6.in-berlin.de>
References: <f22d86810910261019yc77dbf0sa7688a98e7b98267@mail.gmail.com> <7ADB5FD7-9C97-4987-BC20-997258B25FD2@noahdesu.com> <f22d86810910261122j6c9e57e8pd4a257090f65c727@mail.gmail.com> <4AE5F04E.3050908@nortel.com> <f22d86810910261200n130fda06r46fdbcc808195002@mail.gmail.com> <E1A2BB8B-F291-4C9E-B095-39F0AE7A0587@noahdesu.com> <4AE5F9B9.2010707@s5r6.in-berlin.de>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <FB7BE58D-B492-411D-A630-7F7A4424FD30@noahdesu.com>
Cc: "Leonidas ." <leonidas137@gmail.com>, Chris Friesen <cfriesen@nortel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Noah Watkins <noah@noahdesu.com>
Subject: Re: Difference between atomic operations and memory barriers
Date: Mon, 26 Oct 2009 12:42:50 -0700
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Noah Watkins wrote:
>>> So we can safely assume that pointer assignment will be done in an
>>> atomic manner?
>>
>> See the the comment above rcu_assign_pointer in
>> include/linux/rcupdate.h
>
> This comment only talks about ordering, not about atomicity.
Ahh, yeh that's true.

>
> Again, AFAIR the ISO C spec should explain what is going to be
> guaranteed atomic and what might not be atomic.
This seems likely. I wonder if there are any strange architectures
out there that have some insane implementation.

>

