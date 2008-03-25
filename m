Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbYCYU3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbYCYU3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYCYU3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:29:36 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:44453 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbYCYU3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=fA29xQqLTNBPZhgQUbgcwKEDFlLWmmmF1ATLb51xyBrOm2WIbFpT2qzCH1HuEdMulgIT7Je8a64xp351G3cvOTMU8n+r713AbSLhgGzDOZs9/ApL1YxAbhT53mpGv/SW2RD3PB4IfyNkZigyrQ84CoSAqWmMEtx1ijNrGxpZg7Y=
Message-ID: <998d0e4a0803251329o4dabd28ck5197838fe6920441@mail.gmail.com>
Date: Tue, 25 Mar 2008 21:29:34 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Poor performance now? Please, put weighted velocities ctxts/s to the sched.decision!
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1] "Performance changes between 2.6.13 and 2.6.23"
http://lkml.org/lkml/2008/3/25/102
On Tue, Mar 25, 2008 at 1:34 PM, Sanders, Rob M. <sanders-rob@zai.com> wrote:
> Of more particular concern, the main application that I build has seen a 4-5X
> slowdown in performance.  Under YDL4.0.91 I could process roughly 1e8 data
> points in ~2 seconds, and under YDL6.0 I now process 1e8 data points in
> ~8 seconds.  Total CPU loading (from top) is about 5%, under both systems.
...
> YDL4.0.91 system is context switching about 7000 per interval, whereas the
> YDl6 system is context switching about 1200 times per interval.

It's the velocity, ctxts/interval, a parameter not recognized by the scheduler.

I said them to put the proposal of putting the counters and velocities fields
to the task's struct for the scheduler can take a good decision, the past month.

More weight in higher ctxts/s for the scheduler=> more interactivity.

[2] "Re: Serious performance regression in Wine applications and Linux 2.6.24.*"
http://lkml.org/lkml/2008/3/25/181
On Tue, 25 Mar 2008 08:49:13 -0700, "Ray Lee" wrote:
> Andi's idea of looking for excessive context switches is good -- I
> didn't see a response to that one. Other than that, if you're only
> noticing the issue in 3d games, then it could be several things (not
> just the scheduler).

The kernel needed the velocity parameter to gain it: ctxts per interval
(normally ctxts/s or ctxts/minute).

The proposal of the past month was here:

"Please, put 64-bit counter per task and incr.by.one each ctxt switch."
http://lkml.org/lkml/2008/2/23/398
http://lkml.org/lkml/2008/2/23/401
http://lkml.org/lkml/2008/2/23/406
http://lkml.org/lkml/2008/2/24/1
http://lkml.org/lkml/2008/2/24/103
http://lkml.org/lkml/2008/2/24/157
http://lkml.org/lkml/2008/2/26/159

My proposal is free for yours, quasi-bastards, I won't charge you!

   J.C.Pizarro
