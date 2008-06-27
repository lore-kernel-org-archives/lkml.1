Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbYF0O1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbYF0O1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbYF0O12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:27:28 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:1889 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbYF0O11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xwa85gAyK1Z5iMV+FK0LZyAr/oDVBZLoUuH0A//b1jfhWSaP2ZmYp49aJYsj2LA7XB
         N0pTt83gY52Hh/lRocx2liJg/iC4/tV9C82y9AoDY7mRn6qH/Do2PCoHxQQyCAh/CVTW
         Tw8f8mLgJcEnA91IP6AYDdlYXY8b2SWyyWv5c=
Message-ID: <b647ffbd0806270727m36ec7324odab60e0591d26891@mail.gmail.com>
Date: Fri, 27 Jun 2008 16:27:25 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "=?GB2312?B?z8TBwQ==?=" <xiaiaxaxi@sjtu.edu.cn>
Subject: Re: How can I migrate a currently running task?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080627211712.6cto2d1zks848c88@webmail1.sjtu.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080627211712.6cto2d1zks848c88@webmail1.sjtu.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/27 夏亮 <xiaiaxaxi@sjtu.edu.cn>:
> Hi,
>
>      I am working on Intel Duo Core with Linux OS 2.6.21, and I'd like to
> migrate task from one cpu to another cpu.
> In SMP systems, load_balance() function uses move_tasks() to move processes
> from source runqueue to local runqueue, but it does not move a currently
> running task. If I want to migrate a currently running task from source
> runqueue to local runqueue, how can I do? Any suggestion is preferred.
> Thanks!

Some high-prio task takes away CPU from a 'target' task and then
pushes it onto another CPU. That's what 'migration_thread' does.

Take a look at use-cases of migrate_task() in sched.c.


>
>    Liang
>

-- 
Best regards,
Dmitry Adamushko
