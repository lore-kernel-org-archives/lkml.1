Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbXIXVvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbXIXVvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbXIXVvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:51:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:26575 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbXIXVve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gq47TgaSaZYRoohAV6r/Dk4gXwQFo3vrEo9Sz/EDTGNpzjSKYfbFz//a1Ycoem5oe3CYFdTN8sGIGU1SW/KtIt6xBMJkPd50QN5OXrUBhbxUxlyN158yA5ouwQqlWo/HSZkwBSlPNkllcOQdZyvc9QdAl6ck1Gcu8qoEYdA11RY=
Message-ID: <b647ffbd0709241451r23a8f12fld9d5cccc987ed57@mail.gmail.com>
Date: Mon, 24 Sep 2007 23:51:29 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>
Subject: Re: [PATCH] sched: cleanup adjusting sched_class
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <46F8236B.9020902@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46F8236B.9020902@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/09/2007, Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> Hi Ingo and Dmitry,
>
> I made a clean-up patch about fixing invalid sched_class use.

thanks!

>
> Dmitry, could you please review and sign it?
>
>
> The adjusting sched_class is a missing part of the already existing
> "do not leak PI boosting priority to the child" at the sched_fork().
> This patch moves the adjusting sched_class from wake_up_new_task()
> to sched_fork().
>
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>


-- 
Best regards,
Dmitry Adamushko
