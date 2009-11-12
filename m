Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbZKLSAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbZKLSAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZKLR76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:59:58 -0500
Received: from emroute4.ornl.gov ([160.91.86.27]:49963 "EHLO emroute4.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713AbZKLR76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:59:58 -0500
X-Greylist: delayed 3504 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Nov 2009 12:59:58 EST
Date: Thu, 12 Nov 2009 12:01:32 -0500
From: David Dillow <dave@thedillows.org>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
In-reply-to: <4AFC26AF.8050609@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-id: <1258045292.5944.8.camel@lap75545.ornl.gov>
MIME-version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <20091110034831.GB26809@elte.hu> <20091110041452.GA25575@suse.de>
 <1257863388.4184.220.camel@mulgrave.site> <20091110193747.GB12686@suse.de>
 <1257965424.11985.9.camel@mulgrave.site>
 <alpine.LFD.2.01.0911111153390.31845@localhost.localdomain>
 <1257970010.11985.17.camel@mulgrave.site>
 <alpine.LFD.2.01.0911111211270.31845@localhost.localdomain>
 <4AFB301C.3050800@zytor.com>
 <alpine.LFD.2.01.0911111350290.31845@localhost.localdomain>
 <20091112074531.GA16434@elte.hu> <4AFC26AF.8050609@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 07:15 -0800, H. Peter Anvin wrote:
> On 11/11/2009 11:45 PM, Ingo Molnar wrote:
> > 
> > That's already possible via the git-commits-head@vger.kernel.org email 
> > list. Anyone can subscribe to it and can procmail process it. It is also 
>
> There are a couple of disadvantages with this -- a hera -> vger -> hera
> bounce, in particular (those two machines are nowhere close to each
> other, and there can be huge latecy.)  For real-time robots running on
> hera, a lower-latency mechanism would be useful.

Change the hook on hera that sends the email to use a local alias that
includes git-commits-header@vger and a local list that processes on hera
can subscribe to? That could avoid the bounce...
