Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0CIWoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 17:44:00 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:44616 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0CIWn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 17:43:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VUEaTOoUfY/Oijma8kEo1iGf1j2w3w6OJ94eMGczeC8CTngYiavfWDuul8QOD+5cKu
         85opRxn41EtEF5vDKFzsY7OQn4Dhkpl4ATe6GLfUF2YGFhZhq2HSzMzm1YYA8YdZ3JDb
         nHuqP43BTpCqWuVO+bkw4597gQHVSwim3Qj0Q=
Date: Tue, 9 Mar 2010 23:43:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Till Kamppeter <till.kamppeter@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       lsb-discuss@lists.linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux wireless GSoC 2010 project ideas
Message-ID: <20100309224347.GD5058@nowhere>
References: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com> <20100128231545.GH18683@nowhere> <43e72e891001281523s56707279x896ab059e6d4e530@mail.gmail.com> <4B62231F.5080104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B62231F.5080104@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 12:51:59AM +0100, Till Kamppeter wrote:
> No problem for students to suggest topics. We are not restricted to  
> wireless in terms of kernel. We support kernel projects in general.
>
> Please give your suggestion as answer to this e-mail, doing "Reply to  
> all", as I am not a kernel export, the other participants of this thread  
> should have a look at the student's project ideas and help finding 
> mentors.
>
>    Till



Ok, I hope it's not too late.
Here is one subject that I would like to apply for:


= Improving tracing in perf events / ftrace =


Using trace events under perf events is still a young feature
and needs various improvements.

- Syscall events can carry only raw values and addresses.
We need to make them "aware" of strings and structures contents
from userspace.

- Make function / function graph tracers usable by perf

- Optimize tracing fast-path

- Improve perf tools to better handle trace events scalability

- Provide new perf tools that exploit trace events (scheduler
  migration analysis, etc...)

- Implement a per context excluding (eg: exclude irqs, exclude functions, etc...)

- There are always things to do there.


Of course, each of these elements require a lot of work,
so not all of them can be done in two months, and some
of them can be started already before the summer.

