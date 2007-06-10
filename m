Return-Path: <linux-kernel-owner+w=401wt.eu-S1761269AbXFJUod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761269AbXFJUod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 16:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbXFJUo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 16:44:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:52048 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbXFJUoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 16:44:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W40JIrQJfhTyMvIKzMhrsVgj5c9g7tNBaVXYLZ2sIyQadOMarkSgn4kpHocrxE+Ez7e2w94dxRE3iugGGX3MEQ+2JMXtabz6JqnQok9i0rO0YDK6fS+YJCJZyRcEOVkxxQF3i8H0ywrRCBWMlLUDOUxjRnalVvTJ1T8Fy+syfYs=
Message-ID: <5bdc1c8b0706101344o78d202dcx5cfdaea0fd73ddf7@mail.gmail.com>
Date: Sun, 10 Jun 2007 13:44:21 -0700
From: "Mark Knecht" <markknecht@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.21-rt9 - IRQ23 consuming a steady 2.7% of CPU
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Lee Revell" <rlrevell@gmail.com>
In-Reply-To: <20070610180745.GA14912@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5bdc1c8b0706100946k3acd6374uac8248e78f97433d@mail.gmail.com>
	 <20070610172452.GA7560@elte.hu>
	 <5bdc1c8b0706101038q2f0e3418t1a595e749b5bfe71@mail.gmail.com>
	 <20070610180745.GA14912@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/10/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Mark Knecht <markknecht@gmail.com> wrote:
>
> >   GMail is being kranky. Can you please send the patch as a zipped
> >   attachment?
>
> you can pick it up from:
>
>    http://people.redhat.com/mingo/realtime-preempt/testing/forcedeth-rt-tweak.patch
>
>         Ingo
>

Hi Ingo,
   Yep, that solved it on my machine. I did have to patch using 'patch
-p1 -R' I think that's because the paths in your patch file are maybe
based on your work setup? I don't know. I'm amazed most of the time
that I can even do this stuff but with your help it seems to work out.
Thanks.

   Anyway, top no longer reports the 2.7% CPU usage from IRQ23. I do
see a little bit of CPU  consumption from X and firefox but that seems
pretty reasonable.

   If there is more you'd like me to look at or do on my end please let me know.

Cheers,
Mark
