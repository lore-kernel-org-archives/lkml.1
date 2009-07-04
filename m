Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbZGDSKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbZGDSKE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 14:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbZGDSJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 14:09:54 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:61852 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbZGDSJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 14:09:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject:in-reply-to:references;
        b=Qm29QhgZKmc61PvffRpXIhRcb5R7AjdC05J3wotuphlXJSjTFdsdYH5hTc3GDbr915
         D4j4FSUeuK4SJvEdNzBLdpjez8zprIS3bOqHrM4octEwIntUV2QD3HyLdGHhekyeAdo3
         IZDJ3PWjSTmWXtgUBvNXyJdkYe1bPfCNf1Lwk=
Message-ID: <4a4f9af3.27015a0a.48c6.ffffa6d5@mx.google.com>
Date: Sat, 04 Jul 2009 11:09:55 -0700 (PDT)
From: "Michael Witten" <mfwitten@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Johannes Stezenbach" <js@sig21.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.30: hibernation/swsusp lockup due to acpi-cpufreq
In-Reply-To: <cNOy0-5C5-23@gated-at.bofh.it>
References: <cNOy0-5C5-23@gated-at.bofh.it> <cNtMS-6Iq-11@gated-at.bofh.it> <cNuzd-7VN-3@gated-at.bofh.it> <cNHPT-3kB-1@gated-at.bofh.it> <cNM3f-1ty-29@gated-at.bofh.it> <cNMZg-2ZR-17@gated-at.bofh.it> <cNNsg-3U5-3@gated-at.bofh.it> <cNNLx-4kf-5@gated-at.bofh.it> <cNOeG-5cB-23@gated-at.bofh.it> <cNOok-5pJ-11@gated-at.bofh.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 23:39:59 +0200, Rafael J. Wysocki wrote
(http://www.spinics.net/lists/linux-acpi/msg22661.html):

> In fact, we need to do this entire thing differently.
> 
> The basic problem is that cpufreq_suspend() is a sysdev thing, so it will 
> always be called with iterrupts off and *only* for CPU0.  So, it looks like
> the majority of things we do there is just unnecessary (at least).

What's the status? This bug is driving me nuts.

Thanks,
Michael Witten

PS

See http://groups.google.com/group/linux.kernel/browse_thread/thread/bb3f4e0fc32273c4/e83178dfc9374669

