Return-Path: <linux-kernel-owner+w=401wt.eu-S933058AbXDANqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbXDANqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 09:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933075AbXDANqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 09:46:15 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:21159 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058AbXDANqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 09:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c5OBgl/zmUdzcdxrOle5J8UDr833G0Z3dQGzbEhW5vB0HCBzZVayTJn7WFvxbGdojpkiMMFkrALnT6Z1wr09SeOGjAaNL2fb/wX4BoG8KNKblHCA1Cim2inhq+SJpM0UxbVFRfT5CAiLxO0ydVbNysR3iYtGRpLks056GIkaPMA=
Message-ID: <82e4877d0704010646lf221d3i1880f9e8d76c1a5f@mail.gmail.com>
Date: Sun, 1 Apr 2007 09:46:10 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: xiyou.wangcong@gmail.com
Subject: Re: [-mm3 PATCH] (Retry) Check the return value of kobject_add and etc.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <82e4877d0704010122g24fcd0f2r717f98b1494225e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0704010122g24fcd0f2r717f98b1494225e6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/07, Parag Warudkar <parag.warudkar@gmail.com> wrote:
> >-      kobject_add(&p->kobj);
> >+      if (kobject_add(&p->kobj)) {
> >+              kfree(p);
> >+              return;
>
> Please add a printk warning before the return statement to log a
> proper warning stating what happened, which file and line etc. That
> way people can know why something did not work as expected and
> hopefully do something about it.

Never mind - kobject_add() is already verbose enough when it fails.

Parag
