Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbZBTCxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbZBTCxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZBTCwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:52:54 -0500
Received: from hpsmtp-eml16.KPNXCHANGE.COM ([213.75.38.116]:29147 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029AbZBTCwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:52:54 -0500
From: Frans Pop <elendil@planet.nl>
To: jplatte@naasa.net
Subject: Re: cpuinfo shows wrong MHz value
Date: Fri, 20 Feb 2009 03:52:50 +0100
User-Agent: KMail/1.9.9
Cc: Kasper Sandberg <lkml@metanurb.dk>, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Matthias-Christian Ott <ott@mirix.org>,
       cpufreq <cpufreq@www.linux.org.uk>
References: <200902142217.51655.jplatte@naasa.net> <200902182205.47737.elendil@planet.nl> <200902191803.55347.jplatte@naasa.net>
In-Reply-To: <200902191803.55347.jplatte@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902200352.51173.elendil@planet.nl>
X-OriginalArrivalTime: 20 Feb 2009 02:52:52.0215 (UTC) FILETIME=[52A12870:01C99306]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009, Joerg Platte wrote:
> Am Mittwoch, 18. Februar 2009 schrieb Frans Pop:
> > commit ed9cbcd40004904dbe61ccc16d6106a7de38c998
> > Author: Zhao Yakui <yakui.zhao@intel.com>
> > Date:   Tue Nov 20 14:20:21 2007 -0500
> >     Revert "speedstep-lib.c: fix frequency multiplier for Pentium4
> > models 0&1"
> >
> > That would exactly explain the factor 8 of the error.
>
> Yes, looks like thats the reason.

It looks as if http://bugzilla.kernel.org/10968 has a fix for this issue, 
but that that patch never got included in the kernel.

For start of current thread, see: 
http://www.gossamer-threads.com/lists/linux/kernel/1034291?page=last
