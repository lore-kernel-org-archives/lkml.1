Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbYDIVkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbYDIVkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 17:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYDIVkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 17:40:45 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:51558 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbYDIVko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 17:40:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hbTeGfXZmIkvv/j9R6AHAKGIdcPkRWQx/KFziqgKADd/yzhrXQT+eoig8yG+FZiPCuMI9tAGQT6w1uuXuKJcCGmB+IFXhyi4xKgDCfNzU6YXRgqe9mTz051HpTsltHUO0UHIclJs+k+nYcWexa6tf+dRQ/2Mg1GEo+PuQv1E1/8=
Message-ID: <dd18b0c30804091440x6e029daes8dd5f4dd848f5154@mail.gmail.com>
Date: Wed, 9 Apr 2008 21:40:42 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: mutex_unlock
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <200804092240.26623.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804090017m75c97f81qf6428b377432f8b5@mail.gmail.com>
	 <200804092240.26623.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2008 at 8:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> On Wednesday, 9 of April 2008, Justin Mattock wrote:
>  > Hello with testing out git(very cool); my first test was with
>  > 2.6.25-rc8-00194-g4cac04d ran vary smoothly;
>  > then I decided to pull the latest git (2.6.25-rc8-00208-g7180c4c)and
>  > see what I might find.
>  > upon reboot the system starts up giving me this:
>  >
>  > Starting up
>  > Decompressing Linux Done
>  > Booting the kernel
>  > __   <-------blinking
>  >
>  > I waited a few seconds or minutes but nothing;
>  > after reading earlier posts about something with a mutex_unlock maybe
>  > this was what I was experiencing.
>  > when loading a live cd and recompiling the same kernel, I noticed
>  > under kernel hacking;
>  >
>  > RT Mutex debugging
>  > Built in scriptable tester for rt-mutexes
>  > Spinlock and rw-lock debugging
>  > Mutex debugging basic checks
>  > Lock debugging detect incorrect freeing of live locks
>  > Lock debugging prove locking correctness
>  > lock usage statistics
>  > Lock dependency engine debugging
>  > spinlock debugging sleep-inside-spinlock checking
>  > Locking API boot-time self-tests
>  >
>  > With not knowing what I was doing I chose yes to all of these options,
>  > then reboot -f,
>  > The system booted up properly,
>  >
>  > Is there a way where I can find out if this was what was going on?
>  > could this be something different?
>
>  Hm, interesting.
>
>  It looks like our locking debugging code may hide some issues ...
>
>  Thanks,
>  Rafael
>

Maybe; weird  having something like that happen.(maybe it was
something like what appletouch is doing i.g. could not do mode request
error. The problem  is it very seldom, every X amount of boots)  I can
go back in the kernel and see if I can find out what option really
caused the system to boot properly(hopefully). Also with suspend; I
update to the latest openGl to see if suspend works, but it seems to
be worst with the latest release, i.g. a few days ago I update xorg to
7.3 with sid, suspend would give me a blank screen but no reboot(I
should of left my mouse on the terminal, then once the blank screen
shows up issue dmesg > suspend), now with the latest update with
openGL(today) I receive a blank screen and a reboot.
Maybe openGl needs to have DRI enabled? in order for this to work...

-- 
Justin P. Mattock
