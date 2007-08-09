Return-Path: <linux-kernel-owner+w=401wt.eu-S937217AbXHIIrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937217AbXHIIrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 04:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760378AbXHIIrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 04:47:13 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:49726 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbXHIIrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 04:47:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S6vsmeLOHL8qRbwb+KLDPFvRS5pjj3aEFMCraN3E8xyRtohSOjpSNTLSLLBigc1E7qpb4kQy8FR3T5dypkNHIvfOrE7Bdb4FVVJre77TbXbyJ1OqTzRIxLPzkdktWjql9HZ9P2AFijbLZ5vig7kuByMUPd0oupx8SQcxdwyMGuI=
Message-ID: <b647ffbd0708090147p2b30e6c8g82aeb8880520265b@mail.gmail.com>
Date: Thu, 9 Aug 2007 10:47:11 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Mitchell Erblich" <erblichs@earthlink.net>
Subject: Re: Question: sched_rt.c : is RT check needed within a RT func? dequeue_task_rt() calls update_curr_rt() which checks for priority of RR or FIFO :
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <000a01c7da3d$3f946ae0$6501a8c0@earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <000a01c7da3d$3f946ae0$6501a8c0@earthlink.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/07, Mitchell Erblich <erblichs@earthlink.net> wrote:
> 1) * Possible wasted stats overhead during dequeue..
> sched_rt.c:
> Is RT check needed within a RT func?
> dequeue_task_rt() calls update_curr_rt()
> which checks for priority of RR or FIFO.
> [ ... ]
> Thus, I think those two lines could be removed.
>
> 2) nit....
> The comment within sched_rt.c
> ----->   Adding/removing a task to/from a priority array:
> Is placed before dequeue_task_rt() where
> enqueue_task_rt() is placed above the comment
>

Both suggestions sound good. I guess, a patch would be welcomed  :-)


>
> Mitchell Erblich
>

-- 
Best regards,
Dmitry Adamushko
