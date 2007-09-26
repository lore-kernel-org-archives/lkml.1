Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbXIZBoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbXIZBoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 21:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbXIZBoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 21:44:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:16292 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbXIZBoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 21:44:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=e3mhu/6Telpnz3FSKrDaXqLYS4ZuPCJvNLVWfKSIMqmxdpAD7YZZBgWuCZnO2P2Qit+Fz2NsVmFAAiN3L9PzmgJEE5O7pfc+nW+tdDgCX6k5VKQBPto4m6A/+FfNhnKyxBkvPP1fyMUnjuzL424eyYEqhvkPUPuMINVfxmKEXGw=
Message-ID: <46F9B90D.2010709@gmail.com>
Date: Wed, 26 Sep 2007 10:42:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Alan Stern <stern@rowland.harvard.edu>, Jonathan Corbet <corbet@lwn.net>,
       ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
References: <Pine.LNX.4.44L0.0709251105540.3909-100000@iolanthe.rowland.org>	 <46F996AD.2070107@gmail.com> <1190763704.2227.24.camel@localhost.localdomain>
In-Reply-To: <1190763704.2227.24.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wed, 2007-09-26 at 08:15 +0900, Tejun Heo wrote:
>> I have no problem with changing the condition check to loop but it would
>> be great if someone can point me to a code where this unexpected wake up
>> is used.
> 
> This is one of those areas where we're conservative.  Historically there
> have been random wakes, and noone is quite sure that signal code or the
> freezer or whatever won't do it under some circumstances.
> 
> Thus it's always seen as better to wait on a specific condition.

I see.  I'll update the code then.  Thanks.

-- 
tejun
