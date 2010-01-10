Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582Ab0AJU6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab0AJU6J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 15:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171Ab0AJU6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 15:58:08 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:61114 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab0AJU6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 15:58:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LT8jROoYOe8uMx74t/InNmO9mT18mS4jZLCMCXaWvUa1RvWpJyxQJjKdA4CUE7h3Rj
         yF5qi2AcBBNwrQfE0F0iRX7O111jM/CmNPT+k5f8crhl4LjA8sqb167CjEsv7MgyTrQU
         25042DMkuYTrRvgm+t8t+I0QYqMGl+DDvhUjo=
MIME-Version: 1.0
In-Reply-To: <8d6898731001042332m6b5b97b0n5515ae166f62aad2@mail.gmail.com>
References: <cf70f0211001040007s5be9f1aas7bb52928c8d50e7c@mail.gmail.com>
	 <8d6898731001042332m6b5b97b0n5515ae166f62aad2@mail.gmail.com>
Date: Sun, 10 Jan 2010 12:58:06 -0800
Message-ID: <f22d86811001101258x3ed5d50bxdfab4abd16610156@mail.gmail.com>
Subject: Re: init_task belongs to "process 0" or "process 1"?
From: "Leonidas ." <leonidas137@gmail.com>
To: Nobin Mathew <nobin.mathew@gmail.com>
Cc: Shivdas Gujare <shivdas.tech@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> init_task is the head of doubly linked list which holds all
> task_structs in the system. init_task is again the task_struct for
> process 0/swapper/idle task. This process is created manually (I meant
> to say not by copy_process() calls). Manually means they are static
> structures defined in the code (see INIT_TASK, init_mm, init_fs etc).
> There will be multiple idle task if there is more than 1 cpu core.
> Idle task is the one which is scheduled if there is no other task
> ready for scheduling.

An idle task per core? So these tasks must be having different pids
right? As per my understanding there is only 1 idle task, in that case
on multiple cores when there is no activties on more than one cores,
how things would work? Same task cant be stored on different cores at
the same time right?

How is this handled?

-Leo.
