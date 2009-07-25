Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbZGYXBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbZGYXBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 19:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZGYXBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 19:01:10 -0400
Received: from mail2.shareable.org ([80.68.89.115]:43731 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbZGYXBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 19:01:09 -0400
Date: Sun, 26 Jul 2009 00:01:00 +0100
From: Jamie Lokier <jamie@shareable.org>
To: sen wang <wangsen.linux@gmail.com>
Cc: Raistlin <raistlin@linux.it>, Peter Zijlstra <peterz@infradead.org>,
       mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: report a bug about sched_rt
Message-ID: <20090725230100.GC15260@shareable.org>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com> <1248437670.6987.26.camel@twins> <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com> <1248441290.6987.52.camel@twins> <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com> <1248520224.8429.83.camel@Palantir> <454c71700907250429i1c77658bt6d65b02f08a29f4a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <454c71700907250429i1c77658bt6d65b02f08a29f4a@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sen wang wrote:
> but, to the realtime system  like a decoder, I think we should meet the rt
> task as we can.

If the realtime task is something like a video decoder feeding a
display, and it is bandwidth-throttled only to ensure things like SSH
and filesystem I/O are still available, then I have to agree with Sen,
you would want any "spare" CPU to go the video decoder in that
application, not the idle task.

> the RT scheduler is mainly used for realtime system which should have the
> different policy from fair task.

The RT scheduler is used for lots of different systems which you
haven't considered.

For your application, probably the way RT-bandwidth works is not
useful.  It's better for some other applications.

-- Jamie
