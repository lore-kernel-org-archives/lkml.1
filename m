Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbYLKBHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbYLKBHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 20:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYLKBHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 20:07:33 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:30812 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYLKBHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 20:07:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Y0WbSGY7AitSCHaRfUZyJOQ52diydcfE9NuYlAd9buCsTHzQt6rFCoQ5SWbaOPGgCE
         eNwWzWBZeiZgI7VNKN/2UW/v89jjsRfjucBYYQHlVL9D058yj8xb65MyjjljW4/IPBlx
         vJ3AqROCxzzzROq6dBpHInGx/2xJSGo2F5xVU=
Message-ID: <8bd0f97a0812101707p7df7745dk9840b05c0b26184b@mail.gmail.com>
Date: Wed, 10 Dec 2008 20:07:26 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] make INIT_FS use the __RW_LOCK_UNLOCKED initialization
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20081210234307.GI28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0812101832200.21545@gandalf.stny.rr.com>
	 <20081210234307.GI28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 18:43, Al Viro wrote:
> On Wed, Dec 10, 2008 at 06:37:28PM -0500, Steven Rostedt wrote:
>>
>> The following patch is in:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
>>
>>     branch: cleanups
>
> Would be better to take init_fs to something in fs/ or kernel/ and kill
> the duplicates, along with INIT_FS macro itself...

how about the next level: unify init_task.c.  a quick check shows that
like 90% of the stuff in there is the same for everyone ...
-mike
