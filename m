Return-Path: <linux-kernel-owner+w=401wt.eu-S1762194AbXGEW0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194AbXGEW0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758413AbXGEW0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:26:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:16017 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570AbXGEW0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:26:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=seaylPMG8GOKZHK46Tb7R/vK5HZDV9pzT74AdCo2DIwAwBeVk0dWKIwUjvaTDR9ib1/pgHto6LJjqVGhF+FuYhU/oP7hMr1P4+ca+XA1Li9gp9z/xS8zPyYIKOpYZJCWJkJLAxmAtJezW2ACMlq8dfsxkg4vGbduY21gQ9p65oQ=
Message-ID: <9a8748490707051526w6629fd3fkcfd57d301f67ddcc@mail.gmail.com>
Date: Fri, 6 Jul 2007 00:26:14 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [-mm Patch] INFINIBAND: check the return value of kmalloc
Cc: "WANG Cong" <xiyou.wangcong@gmail.com>, rolandd@cisco.com,
       mshefty@ichips.intel.com, halr@voltaire.com,
       "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       "Steve Wise" <swise@opengridcomputing.com>
In-Reply-To: <ada1wfm4jea.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070704163741.GA2510@localhost.localdomain>
	 <9a8748490707041700q18608e3ave4465f1181b97e2f@mail.gmail.com>
	 <ada1wfm4jea.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/07, Roland Dreier <rdreier@cisco.com> wrote:
> thanks, I added Jesper's suggestion to the original patch and queued
> this for 2.6.23:
>
> (Steve, let me know if this looks OK or not to you)
>
It certainly looks OK to me :-)


> commit 8d339921a2cb279457dce79f8a308978e0b41b27
> Author: WANG Cong <xiyou.wangcong@gmail.com>
> Date:   Thu Jul 5 14:40:32 2007 -0700
>
>     RDMA/cxgb3: Check return of kmalloc() in iwch_register_device()
>
>     Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>     [ Also remove cast from void * return of kmalloc() as suggested by
>       Jesper Juhl <jesper.juhl@gmail.com>. ]
>     Signed-off-by: Roland Dreier <rolandd@cisco.com>

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
