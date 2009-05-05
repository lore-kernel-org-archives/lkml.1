Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbZEETjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbZEETjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 15:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZEETjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 15:39:40 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:54319 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbZEETjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 15:39:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uJKK1F+t7zTV+QAaBBmenxJvmsneq3sn3ICMj0U0uP+qC678UFIMddlI1TUf5hEYn9
         5iVEhEntuN1irPbJieXP68lM8V5MskhsznfPGBn2TukJMEjpsUnPdy/YlAod8qC3DF3/
         rlroz3rER/roOXXldcwzyuw5OzyZXLDjgSb+I=
MIME-Version: 1.0
In-Reply-To: <20090505133743.GA663@infradead.org>
References: <1240646945-7970-1-git-send-email-abogani@texware.it>
	 <20090425082349.GA2475@infradead.org>
	 <20090505133743.GA663@infradead.org>
Date: Tue, 5 May 2009 21:39:38 +0200
X-Google-Sender-Auth: d1e83f7cc8b35b38
Message-ID: <63a49ef40905051239r61fe7f4cg6f24e13df30dc940@mail.gmail.com>
Subject: Re: [PATCH vfs-2.6:for-next] vfs: remount_fs BKL pushdown
From: Alessio Igor Bogani <abogani@texware.it>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sir Hellwig,

2009/5/5 Christoph Hellwig <hch@infradead.org>:
> On Sat, Apr 25, 2009 at 04:23:49AM -0400, Christoph Hellwig wrote:
>> On Sat, Apr 25, 2009 at 10:09:05AM +0200, Alessio Igor Bogani wrote:
>> > Push BKL down into ->remount_fs()
>>
>> Please also push down lock_super, no need to have two locking changes in
>> this area just after another.
>
> Do you plan to do that respin?  I will need the lock_super pushdown for
> some sync work.  I can wait for you if you plan to submit it, otherwise
> I'll out it on my TODO list.

Apologize I have completely missed your first replay.

Let me two days for finish that task and for do build and boot tests.

Thanks!

Ciao,
Alessio
