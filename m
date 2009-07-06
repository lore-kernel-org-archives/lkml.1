Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbZGFGX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbZGFGX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 02:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZGFGXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 02:23:50 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:34268 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbZGFGXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 02:23:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YJlttq4xsXpFPskjQVTVdSZu2FrPVVcervB9mR3UKhT4HA0OTYoDsLQYDN5ovRPr7J
         Y5RvfSLFWzR+cyh1JLwsRs7/ybM24yT6bgnAqaRS1lpTRRY/sE0VPf5httFJAQbwlCaf
         1g0t/JgPyU/Pq5ZTKn+u4N8UjlAIjQS2H2suI=
MIME-Version: 1.0
In-Reply-To: <4A51966C.3000102@free.fr>
References: <20090703015554.GB5880@cr0.nay.redhat.com>
	 <20090703071504.GG5880@cr0.nay.redhat.com>
	 <412e6f7f0907030040v6133badat7058186a01d78f44@mail.gmail.com>
	 <20090703081655.GH5880@cr0.nay.redhat.com>
	 <412e6f7f0907030127u3d6806dfo9168600e7c71b241@mail.gmail.com>
	 <20090703094229.GI5880@cr0.nay.redhat.com>
	 <412e6f7f0907030259m5556ee2fobbb58d377bce4d17@mail.gmail.com>
	 <4A4DDD54.9030206@free.fr>
	 <412e6f7f0907051812q4b3d7bcfkff73c75da14a9cf4@mail.gmail.com>
	 <4A51966C.3000102@free.fr>
Date: Mon, 6 Jul 2009 14:23:53 +0800
Message-ID: <412e6f7f0907052323g114ccbe0n2d17f3d870e42470@mail.gmail.com>
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

On Mon, Jul 6, 2009 at 2:15 PM, Albert ARIBAUD<albert.aribaud@free.fr> wrote:
>>
>>
>> pipe doesn't support llseek.
>
> I wasn't thinking of actively seeking a file position, but simply that reads
> and writes were independent (and both variable) in size, thus even without
> (l)seeking, each endpoint has an independent read (resp. write) position to
> track what's been read from (resp.written into) it at any time, and such a
> position is, IIUC, single for a given fd, making a fd (a struct file)
> insufficient for representing a pipe.
>
> Amicalement,
> --
> Albert.
>
pipe doesn't refer to pos when reading or writing. Please refer to
pipe_read() and pipe_write() for more detail.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
