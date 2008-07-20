Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbYGTXje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbYGTXje (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 19:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYGTXj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 19:39:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:60690 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYGTXjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 19:39:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=a0Pe4r6uFevr5Csvr7Tp25m7BSxpIVj0XxbckeXV40+4a7OfKph34lPyFCfsKcgjfY
         7Si8InJO4P/yJBvf04H+TZVMEBI5PsIdv8w8qceo2j9W+Z65/7oBMxMKhVmzblEp8paM
         wdaHeNPAyMS10ydINivrOspoUczXA4kHQkP64=
Message-ID: <9871ee5f0807201639l229280abg1d6a25fcbeaa2b4d@mail.gmail.com>
Date: Sun, 20 Jul 2008 19:39:24 -0400
From: "Timothy Normand Miller" <theosib@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Problem: Load average of 6, no I/O, 25% idle time. Why?
In-Reply-To: <9871ee5f0807180549l58e849d9ge6e7deee3d0c37fa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9871ee5f0807180549l58e849d9ge6e7deee3d0c37fa@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 8:49 AM, Timothy Normand Miller
<theosib@gmail.com> wrote:
> I have a four processor box, running three compute loads.  The kernel
> I'm running is 2.6.25-gentoo-r5.
>
> One process has four threads, and it's niced to 19.
> Another process has one thread and is niced to -10
> The last process has one thread and is niced to 0
>
> One processor is always idle.
>
> If I change either the 0 to a -10 or the -10 to a zero, then all four
> cores are properly utilized.
>
> Does this make sense to anyone?  Besides messing with the nice levels,
> is there another way to fix this?

I updated to kernel 2.6.26-gentoo, and I no longer see any of the
problems I observed.  No idle time under any circumstances where the
system has plenty of work to do and no I/O waiting.

Thanks, everyone!


-- 
Timothy Normand Miller
http://www.cse.ohio-state.edu/~millerti
Open Graphics Project
