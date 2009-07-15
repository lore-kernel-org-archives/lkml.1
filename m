Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbZGOP35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbZGOP35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbZGOP34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:29:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59302 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbZGOP3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:29:55 -0400
Date: Wed, 15 Jul 2009 02:29:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Subject: Re: [PATCH 0/8] device async action mechanism
Message-ID: <20090715002916.GC2360@ucw.cz>
References: <1247643512.26272.74.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247643512.26272.74.camel@rzhang-dt>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I notice you are still ccing my @suse.cz address. That one no longer
works :-(. 

> this is the patch set I made to speed up the device
> suspend/resume/shutdown process.
> 
> A new mechanism called Device Async Actions is introduced in this patch set.
> The basic idea is that,
> 1. device declares to support certain kinds of device async action,
>    like suspend, resume, shutdown, etc.
> 2. a async domain is create for this device
> 3. the child device inherits the async domain
> 4. devices in the same domain suspend/resume/shutdown asynchronously with
>    the other devices.
> 
> Currently, in order to make sure that it won't bring any side effects,
> I only convert the ACPI battery and i8042 to use this framework, which reduces
> 0.5s+ S3 time(suspend time plus resume time)???, from 7.0s to less than 6.5s.
> and about 0.5s shutdown time in my test.

Hmm, 7seconds is still quite long. What hw is that?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
