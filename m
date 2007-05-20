Return-Path: <linux-kernel-owner+w=401wt.eu-S1758663AbXETQop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbXETQop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 12:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758867AbXETQoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 12:44:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:27238 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758315AbXETQoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 12:44:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BcSQnND6xdgojV8NBRVLt3MOkD+DPSQuV8TIib/9aFiU3+ZGNVlg1yE5dwG9wR4+wk4C3qtD/yaDZl9tC7DZSr2w70FzkBStmUY4tRtzavc5YDi/9HPFL3U4ffoWpRl8IbXWZ69Q8p2Oaex1cv2oztuxwfnCYXcP/w+jUdRTZSg=
Message-ID: <2c0942db0705200944r19a37bd8pd7c220903084e4d3@mail.gmail.com>
Date: Sun, 20 May 2007 09:44:35 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Miguel Figueiredo" <elmig@debianpt.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
Cc: "Bill Davidsen" <davidsen@tmr.com>,
       "Linux Kernel M/L" <linux-kernel@vger.kernel.org>
In-Reply-To: <4650774F.9040208@debianpt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F57DD.2000309@tmr.com> <4650774F.9040208@debianpt.org>
X-Google-Sender-Auth: 0390d3a9836eaf90
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Miguel Figueiredo <elmig@debianpt.org> wrote:
> As I tryied myself kernels 2.6.21, 2.6.21-cfs-v13, and 2.6.21-ck2 on the
> same machine i found *very* odd those numbers you posted, so i tested
> myself those kernels to see the numbers I get instead of talking about
> the usage of kernel xpto feels like.
>
> I did run glxgears with kernels 2.6.21, 2.6.21-cfs-v13 and 2.6.21-ck2
> inside Debian's GNOME environment. The hardware is an AMD Sempron64 3.0
> GHz, 1 GB RAM, Nvidia 6800XT.
> Average and standard deviation from the gathered data:
>
> * 2.6.21:               average = 11251.1; stdev = 0.172
> * 2.6.21-cfs-v13:       average = 11242.8; stdev = 0.033
> * 2.6.21-ck2:           average = 11257.8; stdev = 0.067
>
> Keep in mind those numbers don't mean anything we all know glxgears is
> not a benchmark, their purpose is only to be used as comparison under
> the same conditions.

Uhm, then why are you trying to use them to compare against Bill's
numbers? You two have completely different hardware setups, and this
is a test that is dependent upon hardware. Stated differently, this is
a worthless comparison between your results and his as you are
changing multiple variables at the same time. (At minimum: the
scheduler, cpu, and video card.)

> One odd thing i noticed, with 2.6.21-cfs-v13 the gnome's time applet in
> the bar skipped some minutes (e.g. 16:23 -> 16:25) several times.
>
> The data is available on:
> http://www.debianPT.org/~elmig/pool/kernel/20070520/
>
>
> How did you get your data? I am affraid your data it's wrong, there's no
>   such big difference between the schedulers...

It doesn't look like you were running his glitch1 script which starts
several in glxgears parallel. Were you, or were you just running one?
