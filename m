Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbYG1UOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbYG1UOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYG1UOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:14:44 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:34899 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYG1UOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:14:43 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] filldir write data missing size
References: <87k5fi4l49.wl%ysato@users.sourceforge.jp>
	<871w1pn5wz.fsf@devron.myhome.or.jp>
	<87iqv1wwy1.wl%ysato@users.sourceforge.jp>
	<87r69pk51q.fsf@devron.myhome.or.jp>
	<87abgbgrvt.wl%ysato@users.sourceforge.jp>
	<878wvu9b6n.fsf@devron.myhome.or.jp>
	<20080728190749.GA20019@linux-sh.org>
Date: Tue, 29 Jul 2008 05:14:37 +0900
In-Reply-To: <20080728190749.GA20019@linux-sh.org> (Paul Mundt's message of
	"Tue, 29 Jul 2008 04:07:49 +0900")
Message-ID: <871w1dvk9e.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt <lethal@linux-sh.org> writes:

> On Tue, Jul 22, 2008 at 06:31:12AM +0900, OGAWA Hirofumi wrote:
>> Yoshinori Sato <ysato@users.sourceforge.jp> writes:
>> 
>> > This problem is sh-linux-gcc v4.1.2 and target sh2(a)-bigendian.
>> >
>> > "__put_user(s64, u32_ptr)" compiled.
>> >
>> > Correct code.
>> > *u32_ptr = s64 & 0xffffffff;
>> >
>> > Bad code.
>> > *u32_ptr = s64 >> 32;
>> >
>> > I'm add cast put_user 4byte case.
>> 
>> I see. How about the following patch? I guess the problems of this type
>> should be fixed.
>> 
> I merged a different workaround as no one bothered to CC me on this
> thread. Your fix looks more correct though, please provide a
> Signed-off-by for it and I'll take this over the previous workaround.

Of course. But I didn't test it at all, so please test it.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
