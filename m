Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYG3Wbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYG3Wbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbYG3Wbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:31:40 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:22052 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYG3Wbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:31:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=odsmijDxcR3G7YbWtK6wZr9fBQ7UMNX4edS3ns9qQlO2WiYZjctn+cbMNx/5ypvGUu
         Pf7G7lEoxfe74eBe3WhiLpGxdDC0+k4DE0utDR4X9yeMY73om7P1dtmR15G1lkodZdko
         6xnq6y2wwM8Na8tCy6Tv0NU8srQzStyNqpD/Y=
Message-ID: <7c86c4470807301531i232ebd44m869affe95f036484@mail.gmail.com>
Date: Wed, 30 Jul 2008 15:31:36 -0700
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: linux-kernel@vger.kernel.org
Subject: 2.6.26 new perfmon kernel patch + libpfm + pfmon available
Cc: ia64 <linux-ia64@vger.kernel.org>
In-Reply-To: <7c86c4470807301530s224f5104wdd5004419464bc2e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470807301530s224f5104wdd5004419464bc2e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have released the perfmon2 kernel patch for kernel v2.6.26. There is
no new major features.  Concerning the merge with mainline, we use a different
code base which contains only code to  supports only per-thread counting on
X86 processors. The patch is distributed as a quilt patchset and is
posted on LKML.

Here are some of the kernel changes:
 - Support for Intel architectural perfmon v3 (as per IA-32 Vol3b June 2008)
 - base syscall exported in /sys/kernel/perfmon/syscall
 - experimental utrace support
 - added dep_pmcs[] to PMD definitions to avoid picking up stale config
 - important IBM Power updates to solve counter overflow issues (Corey Ashford)
 - AMD64 APIC/PCI cleanups for IBS support (Robert Richter)
 - new API for handler routine of sampling formats to accomodate IBM
Cell (Carl Love)

There is also a new release for libpfm, now at version 3.5.
The changes include:
 - support for AMD K7 (Vince Weaver)
 - support for Intel architectural perfmon v3
 - support for SiCortex (ICA9A, ICA9B) (Phil Mucci)
 - dynamic perfmon syscall support via /sys
 - new environment variable to control debugging and force particular PMU model

Finally, a new major version of pfmon, now at pfmon-3.5 with some minor
changes:
 - group unknown symbols as UNKNOWN when sampling (Andrzej Nowak)
 - lots of bug fixes

As usual all files and more detailed changelogs can be downloaded from our
website at:

       http://perfmon2.sourceforge.net

Enjoy,
