Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbYGRUqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbYGRUqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYGRUqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:46:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:22258 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYGRUqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=BNlLYHOs1hvlkwTs0+ib14gAXyLrx9TQu6fioL3l6rrj+54mJq2pfcy9Wcg2i8CXca
         Hsgbdz3nglJAMchkX6LlkAH3lmRnAA5U7aS6J7zi4yIY5GfHTFyygsQOU69FPcZZNdHe
         F813W+ImU+40hbijRMDZQ2cN48SoBarxss9tU=
Message-ID: <12c511ca0807181346r7aa8f41co26d079d393ddebae@mail.gmail.com>
Date: Fri, 18 Jul 2008 13:46:35 -0700
From: "Tony Luck" <tony.luck@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Short update and pause in 2.6.27 merge window
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0807170919370.2959@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_55376_2245929.1216413995277"
References: <alpine.LFD.1.10.0807170919370.2959@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_55376_2245929.1216413995277
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Jul 17, 2008 at 9:47 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> We seem to be roughly half-way through the merge window, judging purely by
> number of commits, although part of my calculations there is that I'm
> actually hoping/expecting that because a number of people are on vacation
> etc, this merge window might be smaller than some of the other recent ones
> (2.6.25-rc1 in particular was huge).

That depends on how good people are about putting stuff into linux-next. So far
you've added 3298 non-merge commits in this merge window but the count of
commits in linux-next is less than a thousand below its peak.

We didn't empty linux-next in the last merge, so we probably won't this
time either ... but there are still 4382 commits waiting.

The attached graph of pending work in linux-next was produced with this script
(my linux-next tree has a branch named "linus" which pulls from your tree).

git tag | grep next- | sort | while read tag
do
        c=$(git-rev-list --no-merges $tag ^linus | wc -l)

        echo ${tag##next-} $c
done

-Tony

------=_Part_55376_2245929.1216413995277
Content-Type: image/png; name=linux-next.png
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fit909bp0
Content-Disposition: attachment; filename=linux-next.png

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
------=_Part_55376_2245929.1216413995277--
