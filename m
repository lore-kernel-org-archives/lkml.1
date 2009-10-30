Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbZJ3KUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbZJ3KUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 06:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbZJ3KUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 06:20:11 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:52096 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758AbZJ3KUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 06:20:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=od2/OlSiKUekMe+dhArQNCJrOif0/skHI3TM5TfSDVRNuB5l/PkQeMNdpCPAqry0V7
         sSryg9alBoGiq2QPkYxpYSZ9cE74zJTN+ffwVsEAwtodQXRWkYgsfP6JSPqogdYE945l
         UyvxnFNk+ES3E4+QM/Y/6Q3scNaBGi6bwFLtU=
MIME-Version: 1.0
In-Reply-To: <4AE9F3D2.8030502@nortel.com>
References: <292693080910290808x69f25f6fgc49cb646c1c00466@mail.gmail.com>
	 <4AE9F3D2.8030502@nortel.com>
Date: Fri, 30 Oct 2009 15:50:15 +0530
Message-ID: <292693080910300320q1857cc70s73eb524c34af8233@mail.gmail.com>
Subject: Re: Questions about linux scheduler
From: Daniel Rodrick <daniel.rodrick@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Linux Newbie <linux-newbie@vger.kernel.org>,
       Kernel Newbies <kernelnewbies@nl.linux.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>
>> * A lower priority process will run only if there are no runnable
>> processes in priority above it - this automatically means that all RT
>> processes get to run before non-RT processes.
>
> True for RT, not true for non-RT.  In the current scheduler the non-RT
> tasks are stored in a time-ordered structure rather than the 40
> runqueues that were used before.  A non-RT task will run once it becomes
> the most "urgent" task based on its nice level, how much cpu time it
> uses, and how long it's been since it ran last relative to other tasks
> on the system.

One last question ... the nice value of a process never changes
(unless done explicitly using nice system call), right?

Thanks,

Dan
