Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZBOQll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZBOQll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 11:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZBOQld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 11:41:33 -0500
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:20541 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752909AbZBOQlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 11:41:32 -0500
From: Frans Pop <elendil@planet.nl>
To: jplatte@naasa.net
Subject: Re: cpuinfo shows wrong MHz value
Date: Sun, 15 Feb 2009 17:41:29 +0100
User-Agent: KMail/1.9.9
Cc: Kasper Sandberg <lkml@metanurb.dk>, linux-kernel@vger.kernel.org
References: <200902142217.51655.jplatte@naasa.net> <200902150800.59694.jplatte@naasa.net> <200902150811.36826.jplatte@naasa.net>
In-Reply-To: <200902150811.36826.jplatte@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902151741.30303.elendil@planet.nl>
X-OriginalArrivalTime: 15 Feb 2009 16:41:30.0870 (UTC) FILETIME=[41311960:01C98F8C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009, Joerg Platte wrote:
> Looks like p4_clockmod is responsible for these high values. After
> removing it /proc/cpuinfo shows the correct values:

Can you check whether or not you were also using p4-clockmode with the 
last kernel that did show correct values? The same grep command should 
show this.

It would also help to know which kernel version was the last working one. 
You mentioned 2.6.26, but with some uncertainty. Can you check for 2.6.26 
and possibly for 2.6.27?

Note that p4-clockmode does not really help with power saving, but only 
with thermal management (prevention of overheating). Possibly the 
speedstep or acpi-cpufreq modules will work better for you, but it can 
also be they don't support your processor.
That does not mean this issue should not be looked into of course.
