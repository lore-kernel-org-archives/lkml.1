Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab0BYQNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:13:10 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46900 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932807Ab0BYQNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:13:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ZT5WCMUgVI3nBm0k25Qlqn3NrvAMQCp9nz2oCWQVOsyKvb+y2RxujOqNmyfK3YammK
         JKjmjPJx5NcfMBKYJh23ZQ/2wk4NRLVVJNuDfCkwCfX8hCuMw+CrjyUZktddTqE3rvfa
         HseZzbwLr2Zyezlu8ZH8oB7JT0LjFeyuI5+Qc=
Date: Fri, 26 Feb 2010 00:15:54 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: =?utf-8?B?QW5kcsOp?= Goddard Rosa <andre.goddard@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E . Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Xiaotian Feng <xtfeng@gmail.com>
Subject: Re: [Patch] mqueue: fix the bad code in sys_mq_open()
Message-ID: <20100225161554.GD3842@hack>
References: <cover.1266907495.git.andre.goddard@gmail.com> <a3a62a6cd7cc0ba011949396a1f2c7f9c32aa4b9.1266907496.git.andre.goddard@gmail.com> <2375c9f91002241935k56dff805q57582d998b660889@mail.gmail.com> <7b6bb4a51002242000x49f0b3bdncb40912bf18f90bb@mail.gmail.com> <2375c9f91002242025n1ab73e18i5950aa4f14ea36db@mail.gmail.com> <2375c9f91002242259n2fabb190ic77d6ca603bd1df7@mail.gmail.com> <7b6bb4a51002250249t7e4f03c9r6b2b9a8f348a29aa@mail.gmail.com> <20100225134023.GB3842@hack> <b8bf37781002250741r3836a1calec3441ced7afb863@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8bf37781002250741r3836a1calec3441ced7afb863@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 12:41:47PM -0300, André Goddard Rosa wrote:
>Hi, Américo!
>
...
>I have some questions below:
>
>Inside do_open() and do_create() on mqueue.c, we call
>dentry_open()/__dentry_open().
>
>If dentry_open() fails, it'll automatically call:
>        dput(dentry);
>        mntput(mnt);
>

Oh, I trusted the current code too much, clearly this needs to be fixed
too. I already checked the 14 callers of dentry_open(), and will send
out a patchset to fix this tomorrow. (And the mqueue part will be based
on your patch.)

Thanks!

