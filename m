Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbZFMVoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbZFMVoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 17:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZFMVoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 17:44:15 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:37158 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbZFMVoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 17:44:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=XWgQiRFp+LrKJzBKVO8OAG8X9bUcnEq3gJpyprfVH4QVWTRUyCWFfjcXByQY5hJaMk
         EQ7KkWKRr0NJeGTqliOgl85KLmGxJN1jhbZkePumOiRfbHCF/dLkbJrgXAec1+0ddMoq
         +okXfryoefaVGYlScCVWrO9IKyLpB9eAdWoxg=
MIME-Version: 1.0
Date: Sat, 13 Jun 2009 18:44:16 -0300
Message-ID: <afc5d28f0906131444m11eedd4l4477266135cb869c@mail.gmail.com>
Subject: Scheduler and SMP
From: Bruno Bauer <bgbauer@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I'm new in kernel development and i be making tests in scheduler for a
study course.
I created a new syscall that set a task for no migrate from cpu (I
added a new flag no_migrate on task_struct).
In my tests, a tar/bzip task with no_migrate flag seted run at 5% more fast.

How do this be explained? Overhead of migration?

My changes are in can_migrate_task and balance_tasks (sched.c) and
copy_process (fork.c).

Thanks,

PS: Sorry, my English is poor.

--
Bruno Germano Bauer
