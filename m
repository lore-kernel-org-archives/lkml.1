Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbYLMKIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbYLMKIk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 05:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYLMKIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 05:08:32 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:29988 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752027AbYLMKIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 05:08:31 -0500
X-YMail-OSG: nwgcswcVM1kMDq86nnDOrA6euDxLnDfL.rtH5UqlrmnmkEpLs2YNSOLGQKRqWCHITD.wdApEPlE6XReFKU4Nwlhf9o.DdifEjd.nskBZT2wEVjeQ0uqEc9zyqXKSrzbW_Ew8uXWWMcmOmPfWzaA6fB_nelaAwopyC_9aCESS_3FfHy3vITn2y._xajQ2ni69MCy5Uoxt.6fKyfGM0Mj9p2cJ
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
From: "Nicholas A. Bellinger" <nab@kernel.org>
Reply-To: nab@kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
In-Reply-To: <e2e108260812130141o3d21bbbdob9e7c9f95d309a74@mail.gmail.com>
References: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>
	 <e2e108260812111124j79793adcie106ac2da4f801f3@mail.gmail.com>
	 <1229025513.4153.542.camel@haakon2.linux-iscsi.org>
	 <e2e108260812112321w2f5b1827xe2593888e44808ae@mail.gmail.com>
	 <1229074809.4153.666.camel@haakon2.linux-iscsi.org>
	 <54939.1229149205@turing-police.cc.vt.edu>
	 <e2e108260812130141o3d21bbbdob9e7c9f95d309a74@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 02:08:27 -0800
Message-Id: <1229162907.4153.857.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-13 at 10:41 +0100, Bart Van Assche wrote:
> On Sat, Dec 13, 2008 at 7:20 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> > On Fri, 12 Dec 2008 01:40:09 PST, "Nicholas A. Bellinger" said:
> >
> >> Too bad, because you are missing out on the most advanced ConfigFS
> >> enabled storage engine on the planet.
> >
> > OK. I *have* to ask.. ;)
> >
> > What's the *second* most advanced configfs-enabled storage engine?
> 
> Please don't let Nicholas Bellinger mislead you. The most important
> aspect of a storage engine is stability. Last January I ran
> performance tests on IET, STGT, SCST and LIO. I quickly found out not
> only that SCST had the highest throughput and the lowest latency, but
> also that the performance tests on LIO triggered several kernel
> crashes. I have reported these crashes to the linux-iscsi-target-dev
> mailing list, but even as of today, it's not yet clear whether all of
> these crashes have been fixed. During the last ten years I have filed
> bug reports for many open source projects, and the LIO project is the
> only project where the (kernel) crashes I reported were not addressed
> immediately.
> 
> See also:
> * February 1, 2008, LIO kernel panic during configuration,
> http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/74c8b37f24b84e59/d94c07626bd20521?lnk=gst&q=kernel+panic#d94c07626bd20521.
> * February 8, 2008, kernel crash triggered by LIO,
> http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/30835aede1028188/5708e16a23367fb4?lnk=gst&q=kernel+crash#5708e16a23367fb4.
> * February 13, 2008, LIO target kernel code triggers memory
> corruption, http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/ddc1bf7666372972/2150a09f9ed3d1cd?lnk=gst&q=ipoib#2150a09f9ed3d1cd.
> * February 18, 2008, LIO target makes entire system hang,
> http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/6a76f9efd9409fc5/55bd8840b6a5f757?lnk=gst&q=lio+target+hangs#55bd8840b6a5f757.
> 

Heh.

I have no idea why why you keep bringing up a minor BUG (completely
unrelated to Target_Core_Mod/ConfigFS and LIO-Target v3.0 btw) that was
fixed 10 months ago..?  Perhaps if you spent half the time looking at
actual lio-core-2.6.git code that you do bringing up minor closed bugs
from months ago, you and Vlad would actually understand how ConfigFS
works by now.

Best Regards,

--nab

