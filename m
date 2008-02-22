Return-Path: <linux-kernel-owner+w=401wt.eu-S933379AbYBVIgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbYBVIgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 03:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbYBVIgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 03:36:33 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:8289 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764281AbYBVIga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 03:36:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O25PNowRnPTWIrjEZ5CjdRd46MXb2vPt4eg0LKEp9sQPnCcQqjDcN4r3I8xvo7lpKwDufOVEWS7gzExSaWfKzYr2PWD5r+iZhG4BKxmDTD7/AqceKjzYw6okny4VG+8CbKKFt7TdhPNZMayo6yKkVAsKJPH34cS7yMVaWo9kAKo=
Message-ID: <b647ffbd0802220036v383961ddq5f07efe72f525ffc@mail.gmail.com>
Date: Fri, 22 Feb 2008 09:36:28 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Max Krasnyanskiy" <maxk@qualcomm.com>
Subject: Re: [PATCH sched-devel 0/7] CPU isolation extensions
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Paul Jackson" <pj@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <47BE35B7.2070104@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BE35B7.2070104@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Max,

>  [ ... ]
>  Last patch to the stop machine is potentially unsafe and is marked as experimental. Unfortunately
>  it's currently the only option that allows dynamic module insertion/removal for above scenarios.

I'm puzzled by the following part (can be a misunderstanding from my side)

+config CPUISOL_STOPMACHINE
+       bool "Do not halt isolated CPUs with Stop Machine (EXPERIMENTAL)"
+       depends on CPUISOL && STOP_MACHINE && EXPERIMENTAL
+       help
+         If this option is enabled kernel will not halt isolated CPUs
+         when Stop Machine is triggered. Stop Machine is currently only
+         used by the module insertion and removal.

this "only" part. What about e.g. a 'cpu hotplug' case (_cpu_down())?
(or we should abstract it a bit to the point that e.g. a cpu can be
considered as 'a module'? :-)


-- 
Best regards,
Dmitry Adamushko
