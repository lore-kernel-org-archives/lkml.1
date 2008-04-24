Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbYDXUkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbYDXUkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 16:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbYDXUjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 16:39:46 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:41485 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758364AbYDXUj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 16:39:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AgQ6YRK3oRoJzPtNcOmsbqROX/1kpssZXH1JZGZwvA7qisBiVZf+S3suYJRiA0NVk+UpRbg1o4AGJI7ftKkGKgVVyn8B2yEWPbvcSGpDmCjoUVqUmQqUCYo+yfy29aLtv3WZaeBI2WlKia9wIy+d/dWnE+ZdAnJG/DgagWn0IRk=
Message-ID: <dd18b0c30804241339n34f7e676xee7807c2b1cf71ff@mail.gmail.com>
Date: Thu, 24 Apr 2008 20:39:25 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "James Cloos" <cloos@jhcloos.com>
Subject: Re: Regression: starting X locks box with git master
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <m3hcdrqb03.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m3hcdrqb03.fsf@lugabout.jhcloos.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 7:59 PM, James Cloos <cloos@jhcloos.com> wrote:
> 3dc5063786b273f1aee545844f6bd4e9651ebffe was current when I compiled.
>
>  With that kernel, my laptop locks up as soon as I startx.
>
>  The Xorg.0.log showed that the radeon driver got as far as starting
>  the i2c calls to the M7 video card.
>
>  After that the box would reply to ICMP pings and SysRq-B, but was
>  otherwise non-responsive.  Even SysRq-[KSU] seemed to do nothing.
>
>  v2.6.25 works fine.
>
>  There are 3562 commits (including merges) between those two, and
>  it takes an hour or more for each kernel compile.  Bisecting will
>  be quite painful.  And I only have the one box to work on.  But I
>  will see what I can do.
>
>  Posting before bisecting in case it helps anyone else....
>
>  -JimC
>  --
>  James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
>
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>

I seem to expiriencing lockups as well, vary annoying, "I'm getting
freezes before X is even started", "and after as well." : (
 using nmi_watchdog=1, or nohz=off, or nolapic_timer, or idle=poll
seems to help me with having no freezes, but using powertop
I'm seeing (100%) under AVG residency, which is a bit alarming to me.
If I dont give any boot options and leave my system as it was, I need
to boot and as fast as possible use glxgears to keep the processor at
a certain level, from freezing, but is hard to do.
overall I think this has to do with nohz, right now I have nohz=off
with highress on and the system seems to be behaving properly.
regards;

-- 
Justin P. Mattock
