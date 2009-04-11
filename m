Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbZDKWMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbZDKWMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 18:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759366AbZDKWMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 18:12:20 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33468 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759384AbZDKWMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 18:12:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=ZLsCpOvsbfcNDUbti/3At9bxNiq4j+1rZhPp9xerHTBJdTnyi1jbjcqVyHwDucbO1E
         1os8dzHCx+4vvkd4j62bpBkWSSQjUZkQoSEkiAORdywhBr+62Wk7muguIxYBibk6odL5
         Z6MlXgW5OjMgtPC4T+KN5JPlZkFi+ioLKoomM=
Date: Sat, 11 Apr 2009 23:12:10 +0100
From: "Tiago =?ISO-8859-1?B?U2lt9WVz?= Batista" <tiagosbatista@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Tiago =?ISO-8859-1?B?U2lt9WVz?= Batista" <tiagosbatista@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: High latency on /sys/class/thermal
Message-ID: <20090411231210.68a328c6@ua.pt>
In-Reply-To: <20090411121416.91fe3c88.akpm@linux-foundation.org>
References: <20090411155612.5808570c@ua.pt>
 <20090411121416.91fe3c88.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Apr 2009 12:14:16 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> (cc linux-acpi)
> 
> On Sat, 11 Apr 2009 15:56:12 +0100 "Tiago Sim__es Batista"
> <tiagosbatista@gmail.com> wrote:
> 
> > Hi all
> > 
> > Yesterday, I recompiled my kernel (git + tuxonice)
> > v2.6.30-rc1-1002-gac91f91, there were a couple of issues, the main
> > one is ilustrated bellow.
> > 
> > I am not familiar with the kernel code, but if you give me some
> > pointers, I will be glad to investigate this further
> > 
> > $time cat /sys/class/thermal/thermal_zone0/temp 
> > 34000
> > 
> > real	0m6.613s
> > user	0m0.000s
> > sys	0m0.001s
> > 
> 
> Is this a regression?  Was 2.6.29 OK?
> 
> Thanks.

My last kernel was fine:

$ time cat /sys/class/thermal/thermal_zone0/temp 
48000

real	0m0.007s
user	0m0.001s
sys	0m0.007s


I also forgot to add some information about my kernels...

The good one is 2.6.29 + tuxonice as it was the day after the 2.6.29
kernel was released.

The bad one is a pull from linus tree on april the 9th plus tuxonice on
the same day

from git (hope this helps):
$ git describe v2.6.29-tiago2-ice
v2.6.29-836-g00492ed
$ git describe v2.6.30-rc1-tiago1-ice
v2.6.30-rc1-1002-gac91f91


If tuxonice is a suspect, I will be glad to remove it and recompile.
If I have the time later this weekend, and nothing was found, I will
try to bisect this.

