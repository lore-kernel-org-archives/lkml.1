Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYLZJcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYLZJcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYLZJcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:32:16 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:16071 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbYLZJcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:32:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FvVZ4AMXTN4udHiAiiuuuc8mXfZprGyM/dmmtiGAn/26m8T+B0aHQF1og8fOCijuc+
         84oWxPSwL0tWSBJndMW3J452twaKIyfh0m1zhQU50Y/wd+9StQfGjm1g3Bc1Fv06nbnP
         pyWE6UorOKIe7YYoEb/0u6qaR/KqSCxQl8MnY=
Message-ID: <2375c9f90812260132h6b4b5f94g404f628ec4b74afd@mail.gmail.com>
Date: Fri, 26 Dec 2008 09:32:13 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: "Johannes Weiner" <hannes@cmpxchg.org>
Subject: Re: [Patch] uml: drop const qualifier for kernel_execve()
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
In-Reply-To: <20081207195537.GA24808@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <2375c9f90812021451hfd77292yf2463ca99d07b88e@mail.gmail.com>
	 <20081203012051.GA8953@cmpxchg.org>
	 <2375c9f90812030432m771984edkdd0c599bbae9bb3c@mail.gmail.com>
	 <20081203134035.GA17560@cmpxchg.org>
	 <2375c9f90812051702m217ee049i79ce2f9cc8280fb1@mail.gmail.com>
	 <20081207195537.GA24808@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mBQ9WSki029530

On Sun, Dec 7, 2008 at 7:55 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:> On Sat, Dec 06, 2008 at 01:02:16AM +0000, AmÃ©rico Wang wrote:>> On Wed, Dec 3, 2008 at 1:40 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:>> > On Wed, Dec 03, 2008 at 12:32:02PM +0000, AmÃ©rico Wang wrote:>> >> On Wed, Dec 3, 2008 at 1:20 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:>> >> > On Tue, Dec 02, 2008 at 10:51:09PM +0000, AmÃ©rico Wang wrote:>> >> >> UML implementation of kernel_execve() should not have const qualifier,>> >> >> because it will finally call do_execve() which doesn't have.>> >> >>> >> > And you made sure that do_execve() is correctly annotated?>> >> >>> >>>> >> Yes, I checked that.>> >>> > Good.  Then please fix up do_execve() or let the warning stand out as>> > a reminder.>>>> ??>> Confused...>>>> do_execve() is OK, we don't need to fix it.>> I don't see where it writes through @filename.  So it seems the right> fix would be to make do_execve()s parameter const (and as it seems, a> lot more adjustments down this call graph) and not remove a correct> const from a callsite.
Hello, Johannes.
I apologize for my late reply.
Well, not only @filename, but also the next two parameters, but if you alsomake them const in do_execve(), you will get more warnings. :)So I think my patch is correct.
Thanks for your review.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
