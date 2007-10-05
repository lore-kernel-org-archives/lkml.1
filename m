Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbXJEESj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbXJEESj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 00:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbXJEESc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 00:18:32 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3981 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbXJEESb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 00:18:31 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <cebbert@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: SLUB performance regression vs SLAB
Date: Thu, 4 Oct 2007 21:18:24 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEGOHEAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
In-Reply-To: <47057C10.5030603@redhat.com>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 04 Oct 2007 21:19:17 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 04 Oct 2007 21:19:19 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On 10/04/2007 07:39 PM, David Schwartz wrote:

> > But this is just a preposterous position to put him in. If there's no
> > reproduceable test case, then why should he care that one
> > program he can't
> > even see works badly? If you care, you fix it.

> People have been trying for years to make reproducible test cases
> for huge and complex workloads. It doesn't work. The tests that do
> work take weeks to run and need to be carefully validated before
> they can be officially released. The open source community can and
> should be working on similar tests, but they will never be simple.

That's true, but irrelevent. Either the test can identify a problem that
applies generally, or it's doing nothing but measuring how good the system
is at doing the test. If the former, it should be possible to create a
simple test case once you know from the complex test where the problem is.
If the latter, who cares about a supposed regression?

It should be possible to identify exactly what portion of the test shows the
regression the most and exactly what the system is doing during that moment.
The test may be great at finding regressions, but once it finds them, they
should be forever *found*.

Did you follow the recent incident when iperf fout what seemed to be a
significnat CFS networking regression? The only way to identify that it was
a quirk in what iperf was doing was by looking at exactly what iperf was
doing. The only efficient way was to look at iperf's source and see that
iperf's weird yielding meant it didn't replicate typical use cases like it
was supposed to.

DS


