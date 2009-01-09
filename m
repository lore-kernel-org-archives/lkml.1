Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbZAIKLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbZAIKLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbZAIKLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:11:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:56734 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268AbZAIKLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:11:11 -0500
Message-ID: <496722AB.7050805@kernel.org>
Date: Fri, 09 Jan 2009 19:10:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jgarzik@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [fix] Too async libata breakage
References: <b6fcc0a0901081202m30be591fse66e7f38477e0c0c@mail.gmail.com> <20090108221753.78648cd6@daedalus.pq.iki.fi> <20090108125317.648397d2@infradead.org> <49667C36.4080300@gmail.com> <20090108143127.437c15de@infradead.org> <4966974B.3090700@gmail.com> <alpine.LFD.2.00.0901081619330.3322@localhost.localdomain> <49672166.4050606@gmail.com>
In-Reply-To: <49672166.4050606@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 09 Jan 2009 10:10:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Justin P. Mattock wrote:
> Linus Torvalds wrote:
>> On Thu, 8 Jan 2009, Justin P. Mattock wrote:
>>  
>>> O.K. attached is the results of
>>> dmesg after doing a git-pull
>>> (system didn't freeze, but there's
>>> a slew of warnings); i.g.
>>>     
>>
>> That's a different thing now - some very annoying warnings indeed.
>>
>> Tejun, I think it's yours. And I think it should be removed, or at the
>> very least changed into a WARN_ON_ONCE. Because spamming the console
>> with this is not a good idea:

Yeah, that's WARN_ON() on a pretty hot path.  I'll submit a patch to
convert it to WARN_ON_ONCE() but that's a condition which shouldn't
happen in the first place.  Strange.

Justin, can you please post the output of "lspci -nn" and full kernel
boot log?

Thanks.

-- 
tejun
