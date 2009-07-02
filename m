Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbZGBKEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbZGBKEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbZGBKD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:03:59 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:45700 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbZGBKD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:03:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GWui6hrWMLBH8VsR9jkQMhjNtNY4qupdObozhE1nuSGoOzkKfbvNc4loohb7FfxqY+
         LJpATarBS9pLSKfB/nPxyb9A9dzkUrAEomwBBPuwDxwqhMRGRYlGMflsCq7IHipqNVnS
         niRvbi2XxYNbc3Wz58Q+y+806NbBmagLLfOaI=
MIME-Version: 1.0
In-Reply-To: <20090702094620.GE6372@cr0.nay.redhat.com>
References: <412e6f7f0907020036y76abbc7du99c7b695f725be4@mail.gmail.com>
	 <20090702091309.GB6372@cr0.nay.redhat.com>
	 <412e6f7f0907020218m1f4a9651l2c682a9905925bcd@mail.gmail.com>
	 <20090702094620.GE6372@cr0.nay.redhat.com>
Date: Thu, 2 Jul 2009 18:04:02 +0800
Message-ID: <412e6f7f0907020304u166b6d17id1bcf5d334b45c53@mail.gmail.com>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
From: Changli Gao <xiaosuo@gmail.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 5:46 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>>Are you familiar with splice() and tee()? They both use pipes as kernel buffers.
>
> You are not answering the question, obviously.
When you use pipes as kernel buffer handlers, two fd isn't necessary.
Using one will save half of fd resources. Is it obviously?

>
> And you snipped too much, how can you return that fd? Using the return value?
one RW file descriptor is returned. I have answered this in the first post.

> Ah! This will probably break the user-space program...
>
I don't think so. As a skillful programmer, who will trasfter pipe() a
NULL pointer? In any way, it is break sth, but not very seriously, and
won't affact any right and robust program.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
