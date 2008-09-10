Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYIJUK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYIJUK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 16:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYIJUKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 16:10:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:20732 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYIJUKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 16:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pDQFCTzJMu3sjgHGOKk2nAmTgXhlSb34CY6LUGd9jGLJE5UU3kHI6A9Gny6u2wKhmN
         VrAD9IPYNfK2FLCLc8dsXJvEt68LtViIjZe7dp7vA0FqH/IYGDzcPpGfcTUkj2uJ/xrz
         nArfZtfe8Sslhdmav0/6g1lcNnX/2HeoiFOYU=
Message-ID: <6278d2220809101310l1c6e4810q2d5c56ca693a2d43@mail.gmail.com>
Date: Wed, 10 Sep 2008 21:10:42 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [2.6.27-rc5] inotify_read's ev_mutex vs do_page_fault's mmap_sem...
Cc: torvalds@linux-foundation.org, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <200809110612.51736.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220809091403k65187128keec3b401717f1ec0@mail.gmail.com>
	 <200809101407.16323.nickpiggin@yahoo.com.au>
	 <200809110612.51736.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 9:12 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Wednesday 10 September 2008 14:07, Nick Piggin wrote:
>> On Wednesday 10 September 2008 07:03, Daniel J Blueman wrote:
>> > I observed this locking violation [1] while gnome-panel was loading;
>> > this was previously reported at
>> > http://uwsg.iu.edu/hypermail/linux/kernel/0806.3/2881.html .
>> >
>> > Let me know for more information/config/testing. Thanks!
>>
>> Thanks for the report. I've attached a patch you could test. It compiles
>> (and boots a UML here) but I don't think I've actually tested the inotify
>> path at all, so it may explode on you.
>
> Indeed it was wrong, I messed up the waitqueue handling. This one
> survives longer for me...

So far, so good with that last patch. I'll continue testing this and
follow up if I find any problem.

Thanks for the patching, Nick!

Daniel
-- 
Daniel J Blueman
