Return-Path: <linux-kernel-owner+w=401wt.eu-S932160AbZJ3ODy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbZJ3ODy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 10:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932142AbZJ3ODx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 10:03:53 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:63560 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbZJ3ODw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 10:03:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ND4ryu0S2OPopsUYVZ3PIyrRkZn7NzYgkE4WIQzYgeL9cf8Uv6YF0YH6eu/Ph1/5Lj
         lPK5tWH6YeSwv2uEJlZ+HhtFF+l202ZKIMHEVAVYolj+wfX23W7G1k1NlaaBTEY+sfKE
         hSMlU1SWrYnYXFqPGF5Bxq9HvoI5X5RkD1two=
MIME-Version: 1.0
Date: Fri, 30 Oct 2009 10:58:10 -0300
Message-ID: <6217e0a0910300658w1e3b8b1aja988410924b7a20c@mail.gmail.com>
Subject: Help working with a pseudo-progress-based scheduler
From: Lucas Prado Melo <lucaspradomelo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I would like to create a pseudo-progress-based scheduler based
on the priority-based scheduler of the kernel.
I created some fields on task_struct and I've adapted the function
effective_prio() to change the priority based on a modifier.

I need to update the priority modifier every 'n' ticks, how do I do
some action every 'n' ticks?

Also, I need to create a syscall that would take an user-space address
and a pid of the task to change the priority of the task with the
given pid based on the progress data available on the user-space
address.
How do I get the task_struct through the task's pid?

Thanks in advance.
