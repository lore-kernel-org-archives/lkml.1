Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbZJLVGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbZJLVGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758154AbZJLVGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:06:04 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:30903 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598AbZJLVGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:06:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dfrJ/Gfy03WnmmKS+7FYLLtSZ3hHjkmxY5udDALKxdlPRH9+NkPkpuZPDLhrKtuAA4
         3Ioi+8kUVztZodVawMWf/too7FlcQNEFDPSj7XqkAfOfmnNzGcLyJtOiHCBbIeTVq9gX
         iSgL7+amButv4FIK6u858knDwUMUpKGcfU1nk=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0910121615100.5363@gentwo.org>
References: <2d05c4580910121100v702cbdddua9bd8de971fecaa2@mail.gmail.com>
	 <alpine.DEB.1.10.0910121615100.5363@gentwo.org>
Date: Mon, 12 Oct 2009 23:04:55 +0200
Message-ID: <2d05c4580910121404x7d09ea3dvde1aa49b05d2e3fc@mail.gmail.com>
Subject: Re: Real time kernel
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is definition from http://rt.wiki.kernel.org/

-------------------------------------------------------------------------
Real-time applications have operational deadlines between some
triggering event and the application's response to that event. To meet
these operational deadlines, programmers use real-time operating
systems (RTOS) on which the maximum response time can be calculated or
measured reliably for the given application and environment.
-------------------------------------------------------------------------

So for specific requirements I would not say, you get slower kernel,
you get purpose-making kernel, because on these kind of systems you
probably do not do anything. It is probably the system that listens
and responds to some events.

Do you want to say, when using preemption in "normal user mode", Linux
works slower then without preemption ?
It makes sense,

"because the latency of a task only depends on the tasks running at
equal or higher priorities, all other tasks can be ignored."
(http://rt.wiki.kernel.org/index.php/Frequently_Asked_Questions#What_is_real-time.3F)

Thanks
