Return-Path: <linux-kernel-owner+w=401wt.eu-S1422889AbXCOPS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422889AbXCOPS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 11:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422887AbXCOPS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 11:18:57 -0400
Received: from csclub1.cs.uwaterloo.ca ([129.97.7.226]:46879 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422889AbXCOPS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 11:18:56 -0400
Date: Thu, 15 Mar 2007 11:18:55 -0400
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       Russell King <rmk+lkml@arm.linux.org.uk>, Jan Dittmer <jdi@l4x.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
Message-ID: <20070315151855.GQ22464@csclub.uwaterloo.ca>
References: <20070314131934.GL22464@csclub.uwaterloo.ca> <20070314140623.GF3802@enneenne.com> <20070314141253.GM22464@csclub.uwaterloo.ca> <20070314142710.GJ3802@enneenne.com> <20070314144251.GN22464@csclub.uwaterloo.ca> <20070314145239.GK3802@enneenne.com> <20070314153705.GP22464@csclub.uwaterloo.ca> <20070314154732.GP3802@enneenne.com> <20070314205732.GI22466@csclub.uwaterloo.ca> <20070315102912.GV3802@enneenne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315102912.GV3802@enneenne.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 11:29:12AM +0100, Rodolfo Giometti wrote:
> Can you please provide a little help about it? A patch against current
> wiki wuold be great! ;)

Well all I actually did was simply stick #define HAVE_PPSAPI at the tome
of the refclock_nmea.c file.  The configure script in ntp is explcitly
checking for PPS API version 1 so version 2 doesn't match and it claims
you don't have a timepps.h file it can use.  Unfortunately I really have
trouble understanding autoconf scripts and can't figure out where the
code is that tells it how to do the check for timepps.h and the API
version inside it.

> I modify your code add inquiry functionality. Can you please test it?
>
> See http://ftp.enneenne.com/pub/misc/linuxpps/test/ and the wiki at
> http://wiki.enneenne.com/index.php/LinuxPPS_support#Compiling_the_code.

I will try out the ppstest tool.

How come none of the .patch files in
http://ftp.enneenne.com/pub/misc/linuxpps/refclocks/nmea/ can be
accessed?  Does your web server not like serving up .patch files?

--
Len Sorensen
