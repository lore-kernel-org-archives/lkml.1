Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZJYKtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZJYKtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 06:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbZJYKtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 06:49:16 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:63094 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbZJYKtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 06:49:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tsfYn+jbRTM55ZnWASyUhfYToJ7d9ChO/sGgkuAs9rLGOo6ye+P98v8ZUVn8nPobie
         z3nMEGbKyIaWIudJFgDZcql9vJQ8jp27KDZM7Ydo6aoa4jR3gcfqMnk7vti3mSOd4jGO
         4ekC4DbOAAhCDuzOYKdPAcApOqcoYB7aJmYqk=
MIME-Version: 1.0
In-Reply-To: <f22d86810910241107l21159ccdx2203e2b537b7f36@mail.gmail.com>
References: <f22d86810910220629o433ee5d0u9857d1fb1f01cd6@mail.gmail.com>
	 <4AE165A4.70706@ladisch.de>
	 <f22d86810910241107l21159ccdx2203e2b537b7f36@mail.gmail.com>
Date: Sun, 25 Oct 2009 16:19:10 +0530
Message-ID: <f22d86810910250349w6e1c93bai3447164cf700e657@mail.gmail.com>
Subject: Re: Process id recycling and status of tasks
From: "Leonidas ." <leonidas137@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The obvious question which follows from above is what would be the correct
> way to determine whether a process is alive or not using pid_alive()? Using
> pid_task() does not seem correct and seemingly correct way looks unfeasible.
>

I guess, just checking task_struct->exit_state will be okay to do,
right? If exit
state is DEAD then the task is stale, might avoid using the reference counting
counterparts, right?

-Leo.
