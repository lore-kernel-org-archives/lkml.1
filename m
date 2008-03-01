Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbYCAR76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbYCAR76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 12:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbYCAR7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 12:59:49 -0500
Received: from wx-out-0506.google.com ([66.249.82.228]:51889 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbYCAR7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 12:59:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QvuYm+n3m8qhGYfxYaTMS3nt+O4dXqSxMlUfKuy2ITHWyiYMVrljgQKIQOjuFC9dyMLaBawuTNnbmUeIZg6aXwLOXlLD41E7plNPnupn4klG0c7wi3aUdc8ZGj5e7ig9c3OG1cmVgTfhWIXnGYa8ZDwgp9ApfJacWjp4x8QxEV8=
Message-ID: <d6c8ef150803010959t2f82e12q12c182e698d165fe@mail.gmail.com>
Date: Sat, 1 Mar 2008 18:59:48 +0100
From: "Bosko Radivojevic" <bosko.radivojevic@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: High resolution timers on AT91SAM926x
In-Reply-To: <d6c8ef150803010952g666118dfu7679593b3c92c8be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d6c8ef150803010952g666118dfu7679593b3c92c8be@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

 Is there a way to enable high resolution timers on AT91SAM926x? The
best resolution I can get (kernel 2.6.23.11-rt14 with at91 patch from
maxim.org.za) is around 1ms. Is there any other way to get timers with
better resolution?

When I enable CONFIG_GENERIC_TIME and CONFIG_GENERIC_CLOCKEVENTS (as
prerequisites for CONFIG_HIGH_RES) I'm unable to compile at91 part of
kernel.

Is there any "unofficial" patch? I saw that in 2.6.24 high res is
supported for ARM, but AT91 still lacks support.


$ cat /proc/timer_list
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 11995813000 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 999961 nsecs
  .get_time:   ktime_get_real
 active timers:
 clock 1:
  .index:      1
  .resolution: 999961 nsecs
  .get_time:   ktime_get
active timers:
 #0: <c388de9c>, it_real_fn, S:01
 # expires at 1207195374000 nsecs [in 1195199561000 nsecs]

Thanks!
