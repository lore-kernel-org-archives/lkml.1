Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYLGNjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYLGNjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 08:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYLGNjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 08:39:04 -0500
Received: from mail-gx0-f18.google.com ([209.85.217.18]:56071 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbYLGNjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 08:39:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NYGDDovJhPWdM8yNBK2oetVLIHxtyknTTnKsG2EQaqe6WqrHfWya6tV/aVQspF4Z9g
         zhDQ9o7dHQQpU3RE0A3HPcQQSv5/wiMPmtAc7z7nlnDjV2RzHwUD15+3FySkJCEzfbt9
         C7xd0a5d41A5rnFN4NcWsjcM9m/EyLdh8G9Zw=
Message-ID: <b637ec0b0812070539i20684ec2tfc6748f01d99fff9@mail.gmail.com>
Date: Sun, 7 Dec 2008 14:39:00 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12155] Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
In-Reply-To: <b637ec0b0812061208i9520bd0tfd404f1a9c8a95ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
	 <bfPM5B8Tx2B.A.MQH.zoxNJB@chimera>
	 <b637ec0b0812040050g58f3e28dxba5bca8c77bb5a94@mail.gmail.com>
	 <b637ec0b0812061208i9520bd0tfd404f1a9c8a95ba@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, Dec 6, 2008 at 9:08 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> Hi Rafael.
>
> On Thu, Dec 4, 2008 at 9:50 AM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
>> Hi.
>>
>> I'll try -rc7-git probably tonight and 2.6.27.8 when -stable team releases it.
>>
>
> 2.6.28-rc7 survived 7 suspend/resume cycles and then showed the bug.

2.6.27.8 got me really scared. After the resume and the usual hang, my
hard disk did not recover and my rootfilesystem's journal aborted. Of
course I don't have messages to post as the rootfs was at this point
mounted readonly. I read those info from dmesg.

I went back to my dear 2.6.27.4 which is stable and never caused me
any problems.

Unless someone jumps in with some ideas, I'm not going to do testings
anymore. I can't lose my only machine because of this.

Regards,
Fabio
