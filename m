Return-Path: <linux-kernel-owner+w=401wt.eu-S965394AbXAYPSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965394AbXAYPSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965405AbXAYPSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:18:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:55969 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965394AbXAYPSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:18:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JZY3QI/Afi881iKlk+kv9EY1pBtn54qcrDXy41FELGhVkTH9NyV3po37/gS3LPsIZl9rym3CDtBpe9zBnAWWbqrXYLqZTk1SipJU/2WtYVOOQ1G5yQUEEomgUrKiXkYiX+NsPnrh1ZSkqqfyQ2h++WFMnxsXwY7PWM0L3XC0HUc=
Message-ID: <7b69d1470701250718l58dfbc35rd0b24e5935e32331@mail.gmail.com>
Date: Thu, 25 Jan 2007 09:18:43 -0600
From: "Scott Preece" <sepreece@gmail.com>
To: 7eggert@gmx.de
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
Cc: "Pavel Machek" <pavel@ucw.cz>, "Alessandro Di Marco" <dmr@gmx.it>,
       linux-kernel@vger.kernel.org, vojtech@suse.cz
In-Reply-To: <E1HA3iW-0000kF-VU@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7ELhf-4rC-9@gated-at.bofh.it> <7FKM6-7Gy-1@gated-at.bofh.it>
	 <7G6ME-1g2-11@gated-at.bofh.it> <7GqrZ-6YY-1@gated-at.bofh.it>
	 <7GuFj-5pj-5@gated-at.bofh.it> <7GwQL-h3-7@gated-at.bofh.it>
	 <7GzF3-4L6-47@gated-at.bofh.it> <E1HA3iW-0000kF-VU@be1.lrz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/07, Bodo Eggert <7eggert@gmx.de> wrote:
> Scott Preece <sepreece@gmail.com> wrote:
>
> > My own hot button is making sure that the definition of what
> > constitutes user activity is managed in exactly one place, whether in
> > the kernel or not. My naive model would be to put the response at user
> > level, but to provide a single point of definition in the kernel (say,
> > /dev/useractivity or the equivalent) that the user-level daemon could
> > listen to.
>
> Imagine one computer serving two users. Two monitors, two keyboards ...
---

Good point! Of late I've been working on single-user systems, so it
was not at the front of my brain, despite years of building and using
multi-user systems.

It's a point that multi-user systems have struggled with forever (when
somebody inserts a CR in the drive mounted in the system box, which
user do you pop up a media player for?).

I tend to think it's not a kernel-vs-user-space issue, though. To
solve it you need, somewhere, a notion of a "user session" and you
need some way to separate system-level issues (like low-battery) from
user-level issues (like activiating user X's screensaver).
