Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbZGFBNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbZGFBNA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 21:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbZGFBMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 21:12:50 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:44032 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939AbZGFBMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 21:12:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OvtJxiYVOzTYv6RjkCBsEzvmypJTMLQ8aJS3+SECz3WB3npCl2brwdtyhI3HMmN56e
         4PsHgeaCS8IpAUtitZYI/09xnUsE2WmbRVBIsUeedGRgAZoyOX7DL33uwDN41oBMBqiJ
         NlwLdJL6qSooqRCs3GH7dIquUlEJKCKLjk/Zo=
MIME-Version: 1.0
In-Reply-To: <4A4DDD54.9030206@free.fr>
References: <20090703015554.GB5880@cr0.nay.redhat.com>
	 <20090703051917.GE5880@cr0.nay.redhat.com>
	 <412e6f7f0907022242r52ad981fyd51c2a55f41ab228@mail.gmail.com>
	 <20090703071504.GG5880@cr0.nay.redhat.com>
	 <412e6f7f0907030040v6133badat7058186a01d78f44@mail.gmail.com>
	 <20090703081655.GH5880@cr0.nay.redhat.com>
	 <412e6f7f0907030127u3d6806dfo9168600e7c71b241@mail.gmail.com>
	 <20090703094229.GI5880@cr0.nay.redhat.com>
	 <412e6f7f0907030259m5556ee2fobbb58d377bce4d17@mail.gmail.com>
	 <4A4DDD54.9030206@free.fr>
Date: Mon, 6 Jul 2009 09:12:42 +0800
Message-ID: <412e6f7f0907051812q4b3d7bcfkff73c75da14a9cf4@mail.gmail.com>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
From: Changli Gao <xiaosuo@gmail.com>
To: Albert ARIBAUD <albert.aribaud@free.fr>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 3, 2009 at 6:28 PM, Albert ARIBAUD<albert.aribaud@free.fr> wrote:
> Changli Gao a écrit :
>
>> Yea, in many cases, max fd number must be enlarged. More fds means
>> more memory. Although memory is cheaper today, we have to do our best
>> to save money.
>
> Sorry for interrupting, but I don't see how pipe could return a single fd,
> considering there are two (partly) independent ends, each being read (resp.
> written) in their own time, and an fd has only one "current read/write
> position" IIUC.
>
> If the proposal is to have two independent positions (one for reads and one
> for writes) for a single fd, then I am not sure the gain in the number of
> fds used is worth the loss in the increased size of the fd structure.
>
> Am I missing something?
pipe doesn't support llseek.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
