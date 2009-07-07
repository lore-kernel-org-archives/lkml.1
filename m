Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbZGGHpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbZGGHpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 03:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZGGHpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 03:45:31 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:33748 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbZGGHpb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 03:45:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HY2mNIucomykXiWmIr/VnAr5uTGnuUBActmRPA9XnlD4R05ajBwzwUCdpGgVCtIzVp
         ubUKVW3JLfUBegBxdWUOJOBuqHmg3guXeLhHHD9PakpMPqO0TK+KRuIpr2i7np4htyar
         VDofZUkdDoCj7A3xa1LiD0m3dcD8+Gacr+6NQ=
MIME-Version: 1.0
In-Reply-To: <200907070643.56394.vda.linux@googlemail.com>
References: <20090703015554.GB5880@cr0.nay.redhat.com>
	 <412e6f7f0907030259m5556ee2fobbb58d377bce4d17@mail.gmail.com>
	 <4A4DDD54.9030206@free.fr>
	 <200907070643.56394.vda.linux@googlemail.com>
Date: Tue, 7 Jul 2009 15:45:34 +0800
Message-ID: <412e6f7f0907070045o6a17fb10x557108ffde0da11@mail.gmail.com>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
From: Changli Gao <xiaosuo@gmail.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Albert ARIBAUD <albert.aribaud@free.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 7, 2009 at 12:43 PM, Denys Vlasenko<vda.linux@googlemail.com> wrote:
> On Friday 03 July 2009 12:28, Albert ARIBAUD wrote:
>
> As I understand it, the proposal is to make pipe(NULL) return a fd,
> which can be read from and written to. Whatever you write
> is remembered, and can be retrieved by reads later.
>
> standard pipe(two_fds) returns two fds. One is only used for writes.
> Another is only used for reads. Which may be wasteful in some
> situations (like, if you have thousands of pipes).
>
> There is no trick I know of which may be used to "combine"
> these two fds into one, close second one and thus save one fd table slot.
>
Right!

 mkfifo(name);
 open(name, O_RDWR);
 unlink(name);

Is it a trick?


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
