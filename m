Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbYGLBKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbYGLBKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 21:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbYGLBJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 21:09:55 -0400
Received: from mail.crca.org.au ([67.207.131.56]:54735 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365AbYGLBJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 21:09:54 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jul 2008 21:09:54 EDT
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH -mm 1/2] kexec jump -v12: kexec jump
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Huang Ying <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       Horms <horms@verge.net.au>
In-Reply-To: <20080711201149.GB3298@redhat.com>
References: <1215401122.4660.4.camel@caritas-dev.intel.com>
	 <20080708145051.GA14745@redhat.com>
	 <20080711122131.b6461ab1.akpm@linux-foundation.org>
	 <20080711201149.GB3298@redhat.com>
Content-Type: text/plain
Date: Sat, 12 Jul 2008 11:02:17 +1000
Message-Id: <1215824537.7319.7.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2008-07-11 at 16:11 -0400, Vivek Goyal wrote:
> Hi Andrew,
> 
> We can use this patchset for hibernation, but can it be a better way of doing
> things than what we already have, I don't know. Last time I had raised
> this question and power people had various views. In the end, Pavel wanted
> this patchset to be in.  Pavel, can tell more here...
> 
> To me this patchset looks interesting for couple of reasons.
> 
> - Looks like an interesting feature where one can have a separate kernel
>   in memory and one can switch between the kernels on the fly. It can
>   be modified to have more than one kernel in memory at a time.

I'm not sure how useful that would be, though. I already have
functionality in TuxOnIce which allows you to resume a different image
instead of powering off (roughly the same thing when combined with not
removing the image after resuming). It was neat when testing to be able
to switch back and forth, and I developed the code because I imagined
that it could form part of the foundation for switching between a login
screen and users' stored sessions. Is this what you're imagining?

> - So far kexec was one directional. One can only kexec to new kernel and
>   old kernel was gone. Now this patchset makes kexec functionality kind
>   of bidirectional and this looks like logical extension and can lead
>   to intersting use cases in future.

Ah. You mean keeping both kernels in memory at the same time? In the
above, I was replacing one image with another.

> Huang also talks of using this feature for snapshotting kernel and
> invoking some BIOS code in protected mode. I am not very sure how exactly
> are they planning to use it. Huang, do you have more details on this?

As Rafael wrote, snapshotting is a completely different beast.

Regards,

Nigel

