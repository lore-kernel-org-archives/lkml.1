Return-Path: <linux-kernel-owner+w=401wt.eu-S1758330AbXG1Wb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330AbXG1Wb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 18:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbXG1Wbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 18:31:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:63788 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261AbXG1Wbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 18:31:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H+YH/Giq2HyvCNOirlSBBjHvF0pUSVWpK/JHW+259bmt0AGmDvlZQ7l2yu5WgI2A7YcZ0NVUorxVG5a8EA77wlvPT9HtMshWEUwHqJOl4WVDi2ePSgW7OhPYh9yh/BVB+cO6dpXcM7epEi/MQ/tFOsI9yVoqVLHux+fuo09ak+s=
Message-ID: <a9e22dff0707281531m38bfe702nc2b60aea4deea2ba@mail.gmail.com>
Date: Sun, 29 Jul 2007 01:31:49 +0300
From: "Ni@m" <niam.niam@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: sound is interrupting with new kernels
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070723122813.GA9420@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a9e22dff0707211510o3b5e108dk354f5f15ad3ba498@mail.gmail.com>
	 <6bffcb0e0707221716k67815a2ai7f35606b1effa6a3@mail.gmail.com>
	 <a9e22dff0707222125i49adade7seea63f12672aa701@mail.gmail.com>
	 <20070723122813.GA9420@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> could you try CONFIG_HZ_1000 instead of the 250 you are using currently?
> Also, please enable CONFIG_SCHED_DEBUG to improve the output of
> cfs-debug-info.sh.
>
>         Ingo
>
Hi, Igno.
Sorry for so long response, I hadn't opportunity to reboot machine for
new kernel.
I've built 2.6.22 with CONFIG_HZ_1000 and CONFIG_PREEMPT - nothing changed =(.
Interesting that in Totem(Gnome vp) sound isn't interrupting during
video watching.
I'll try other kernels later to find out what is working good for my case.
In gxine(xine-based) sound is interrupting too!

>firstly, could you check whether the ogg123/mpg321 console apps work
>without any audio skipping? If they work fine, does Amarok work fine?
>(Amarok is an X apps that has a high-quality latency design - most other
>X based players are affected by X communication latencies.)

I'm not using amarok but audacious. It's seems that's everything is
alright with it.

I'll send more tests results later.

Best wishes!

Dima
