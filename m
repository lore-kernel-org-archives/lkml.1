Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbZFJUYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbZFJUYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 16:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZFJUYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 16:24:44 -0400
Received: from smtp-out.google.com ([216.239.45.13]:54830 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbZFJUYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 16:24:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=EH/qYgTg5VDPbZEr8L+MqaF9qKdk3NaP6L73My8LOzVuGaNHnI5ahmKUTZ0jd82z4
	HFbnCN9KxnVs+/zVBN3ZA==
MIME-Version: 1.0
In-Reply-To: <20090610194852.GA28787@n2100.arm.linux.org.uk>
References: <20090610103131.GB13885@elf.ucw.cz>
	 <20090610194852.GA28787@n2100.arm.linux.org.uk>
Date: Wed, 10 Jun 2009 13:24:42 -0700
Message-ID: <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 12:48 PM, Russell King - ARM
Linux<linux@arm.linux.org.uk> wrote:
> On Wed, Jun 10, 2009 at 12:31:31PM +0200, Pavel Machek wrote:
>> Is there patch for Dream support for 2.6.30 somewhere? The best I
>> could find is linux-msm tree, which is ... quite a big diff against
>> 2.6.24:
>
> In short not as far as I know, and I'm very disappointed with the state
> of affairs with google.
>
> Basically, the situation surrounding msm can be described as severely
> wanting - bear in mind that it's been over a year since we last heard
> anything from the msm guys as far as code submissions go.
>
> Personally, I think we should delete the entire codeset which was
> submitted into mainline - it's next to useless and all the time that
> folk sit on their hands not maintaining it, it's just not worth having
> it anywhere near mainline.

I'd love to find an effective way to get more of the msm support
cleaned up (as necessary) and into the mainline.  We're bringing our
work forward and rebasing to keep tracking the latest released kernel,
and working on getting core bits we need that other stuff depends on
in -- look at the thread on linux-pm where the wakelock/suspendblocker
framework has been reviewed, revised, resent repeatedly, etc.

The msm7k unfortunately requires a lot of infrastructure to work given
that the baseband (a black box to us) controls much of the world.
Last time around when I tried submitting some of the core ipc support
to talk to it on the lakml, there seemed to be uncertainty about who
even would review that.

We've definitely dropped the ball as far as interacting with folks on
the lakml on this, but I do wonder if there's a better option than
"delete it all."

We have full support for MSM7201A, including fully functional power
management, working on a number of commercially shipping devices that
we'd absolutely love to get into mainline.  Rebasing and bringing this
stuff forward all the time is a lot of work and certainly not the
optimal way to do it.  Getting it in a couple pieces at a time is slow
going, but it seemed to cause frustration with just the small number
of things we were looking for review/approval for...

Brian
