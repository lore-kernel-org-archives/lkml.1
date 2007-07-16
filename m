Return-Path: <linux-kernel-owner+w=401wt.eu-S933333AbXGPQwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbXGPQwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758621AbXGPQwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:52:14 -0400
Received: from [212.12.190.213] ([212.12.190.213]:32967 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754981AbXGPQwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:52:13 -0400
From: Al Boldi <a1426z@gawab.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Hibernation considerations
Date: Mon, 16 Jul 2007 19:51:35 +0300
User-Agent: KMail/1.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>, <david@lang.hm>
References: <Pine.LNX.4.44L0.0707161045520.3410-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707161045520.3410-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707161951.35225.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Mon, 16 Jul 2007, Al Boldi wrote:
> > From a kexec'd hibernation kernel pov, both S3 and S4 look conceptually
> > exactly the same.  The only difference is, in S3 the memory is in memory
> > and in S4 the memory is on storage.  All device handling is exactly the
> > same, so if there is a problem with device handling between the kexec'd
> > hibernation kernel and the normal kernel, then that would have made
> > itself visible.
>
> You have contradicted yourself.  "In S3 the memory is in memory and in
> S4 the memory is on storage".  How does the memory get onto storage?
> The kexec'd hibernation kernel writes it there.  To do so it accesses a
> storage device.
>
> Consequently the device handling _cannot_ be exactly the same in S3 and
> S4.

Ok, you should have read this in the context of suspending/resuming from/to 
the normal kernel, and in that case they are exactly the same, i.e. kexec -e 
for suspend and kexec -j for resume.

BTW, it would be really helpful if people would actually try the kexec 
hibernation patches, as this may yield a much more constructive discussion.


Thanks!

--
Al

