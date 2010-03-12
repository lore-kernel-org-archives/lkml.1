Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab0CLFaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 00:30:17 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36150 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab0CLFaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 00:30:15 -0500
MIME-Version: 1.0
In-Reply-To: <1268369163.4828.1.camel@jlt3.sipsolutions.net>
References: <1268347174.4142.11.camel@jlt3.sipsolutions.net> 
	<1268348199.4142.33.camel@jlt3.sipsolutions.net> <ac3eb2511003112021o647a288dr453836bb94460af4@mail.gmail.com> 
	<1268369163.4828.1.camel@jlt3.sipsolutions.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 12 Mar 2010 06:29:58 +0100
Message-ID: <ac3eb2511003112129i2274b018m7e059f348d5f983a@mail.gmail.com>
Subject: Re: [PATCH] firmware class: export nowait to userspace
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Tomas Winkler <tomasw@gmail.com>,
       Greg KH <greg@kroah.com>, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 05:46, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2010-03-12 at 05:21 +0100, Kay Sievers wrote:
>> The firmware_class already always exports a TIMEOUT= value, right? If
>> this is the case, it should be set to 0, I guess.
>
> Yes and no. It is exported, but typically it will be 60 seconds. And
> even in this case it makes sense to eventually time out when userspace
> is not responding.

Ok, I didn't expect the async version to time out. Sounds fine then.

>> Sounds fine to have a flag like this, while "NOWAIT" is, I guess, a
>> pretty bad name from the event perspective. This name might make sense
>> for the called kernel function, but not so much for a firmware loader
>> instruction.
>
> Yeah, I can agree with that. How about "ASYNC" or so? It needs to
> distinguish between "I'm going to wait for this please respond" and "I'm
> not really waiting, please let me now when you can".

Yeah, sounds fine to me.

Thanks,
Kay
