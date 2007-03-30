Return-Path: <linux-kernel-owner+w=401wt.eu-S1751308AbXC3Fb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbXC3Fb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 01:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXC3Fb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 01:31:27 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:56739 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbXC3Fb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 01:31:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dqq38LFJM67lmWQqTDoxbc5gUcharZdo14HJk/TLv1rMWlKMLoqpUaXmrdup/UITInJbKOHK9C8UhXL3VKnGQvTgHSHca591F7vrLPL7+BSiK1Nk0quocx6gAC9uoTQG37rerehS4qFvrWxu5Nhg35R9L6nhWvCYylK+inp8pj8=
Message-ID: <6d6a94c50703292231m6c7a4b2fkd0c3cbeb86214497@mail.gmail.com>
Date: Fri, 30 Mar 2007 13:31:24 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "Lee Revell" <rlrevell@joe-job.com>
Subject: Re: [Quick question] serial core issue
Cc: rmk@arm.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <75b66ecd0703292205g6e8f1e99r1985b0a421d4d593@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6d6a94c50703292052p2181cc89l2e217cd05ed36221@mail.gmail.com>
	 <75b66ecd0703292205g6e8f1e99r1985b0a421d4d593@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/07, Lee Revell <rlrevell@joe-job.com> wrote:
> On 3/29/07, Aubrey Li <aubreylee@gmail.com> wrote:
> > When register serial driver as a console, the driver function
> >
> > my_remove()
> > my_shutdown()
> >
> > seems be never called.
> >
> > So the driver can't reclaim resource when the command "reboot" is issued.
> >
> > Is it intended?
>
> Please post your code for review and someone can probably help.
>

It's here:
http://lkml.org/lkml/2007/2/28/351

Thanks,
-Aubrey
