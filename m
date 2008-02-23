Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbYBWP6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbYBWP6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 10:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbYBWP6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 10:58:01 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60051 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751717AbYBWP6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 10:58:00 -0500
Date: Sat, 23 Feb 2008 09:57:52 -0600
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: kosaki.motohiro@jp.fujitsu.com, maxk@qualcomm.com,
       alan@lxorguk.ukuu.org.uk, adilger@sun.com, akpm@linux-foundation.org,
       daniel.spang@gmail.com, mingo@elte.hu, jonathan@jonmasters.org,
       marcelo@kvack.org, pavel@ucw.cz, a.p.zijlstra@chello.nl,
       riel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Tiny cpusets -- cpusets for small systems?
Message-Id: <20080223095752.25c1ba28.pj@sgi.com>
In-Reply-To: <6599ad830802230709m5f0cbf8aia2710bd832408ba7@mail.gmail.com>
References: <20080223060911.e1d13cc1.pj@sgi.com>
	<6599ad830802230709m5f0cbf8aia2710bd832408ba7@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> I'm don't think that either of these would be enough to justify big
> changes to cpusets or cgroups, although eliminating bloat is always a
> good thing.

My "tiny cpuset" idea doesn't so much eliminate bloat, as provide a
thin alternative, along side of the existing fat alternative.  So
far as kernel source goes, it would get bigger, not smaller, with now
two CONFIG choices for cpusets, fat or tiny.

The odds are, however, given that one of us has just promised not to
code this, and the other of us doesn't figure it's worth it, this
idea will not live long.  Someone would have to step up from the
embedded side with a coded version that saved a nice chunk of memory
(from their perspective) to get this off the ground, and no telling
whether even that would meet with a warm reception.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
