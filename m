Return-Path: <linux-kernel-owner+w=401wt.eu-S933567AbXGQPec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567AbXGQPec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbXGQPeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:34:24 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:32942
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbXGQPeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:34:24 -0400
Date: Tue, 17 Jul 2007 08:19:32 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jim Crilly <jim@why.dont.jablowme.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <20070717104231.GA32486@srcf.ucam.org>
Message-ID: <Pine.LNX.4.64.0707170818460.19248@asgard.lang.hm>
References: <200707151433.34625.rjw@sisk.pl> <200707161406.28539.rjw@sisk.pl>
 <20070716123849.GC14212@grifter.jdc.home> <200707161729.16440.rjw@sisk.pl>
 <Pine.LNX.4.64.0707162119500.19248@asgard.lang.hm> <20070717104231.GA32486@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Matthew Garrett wrote:

> On Mon, Jul 16, 2007 at 09:28:13PM -0700, david@lang.hm wrote:
>
>> why would the type of hibernate that I'm talking about (power off, not S4
>> mode) not work on a box that has ACPI?
>
> Powering off rather than using S4 means you lose most wakeup device
> support. That would be a functional regression compared to the current
> code.

only if the kexec isn't able to initialize those devices.

David Lang
