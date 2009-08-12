Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbZHLPrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbZHLPrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbZHLPrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:47:16 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:49294 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbZHLPrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:47:13 -0400
X-Greylist: delayed 1232 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Aug 2009 11:47:12 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A828AE9.9090807@cam.ac.uk>
Date: Wed, 12 Aug 2009 09:27:05 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: RFC: Merge strategy for Industrial I/O (staging?)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

IIO is intended to be a subsystem for sensors such as ADCs, accelerometers,
gyros, light sensors and others that have reasonably high update rates and
typically are connected via i2c or spi busses.

The latest patch set posted to lkml was v4
http://thread.gmane.org/gmane.linux.kernel/860693
Tree at 
http://git.kernel.org/?p=linux/kernel/git/jic23/iio_v4.git;a=summary

original discussion of the need for such a subsystem:
http://lkml.org/lkml/2008/5/20/135

The last couple of versions of IIO have recieved some useful feedback from
a number of people, and feedback from various users has led to a number
of recent bug fixes.  Unfortunately, full reviews of any given element have
not be forthcoming.  Several people who have in principle offered to help
haven't had the time as yet.

In the short term, the lack of review of the core (patch 1 of the above set)
leads to a stack of device drivers sitting in the git repository waiting on
the core being merged. Currently in the tree there are 3 acceleromters, an
adc and a light sensor.  I also have an IMU driver (ADIS16350 family) that
needs a little more cleaning up and testing with latest IIO core.

Increasing numbers of drivers that would fall within the scope of IIO are
being submitted to various other subsystems (hwmon for example) and getting
bounced out as inappropriate for that subsystem.  So, whilst I'd be reasonably
happy to maintain the subsystem out of kernel until interest in the devices
covered grows, or people have time to assist, I was wondering whether it
would be appropriate to submit the subsystem and the associated driver
set to staging.

Whilst some elements could definitely do with more work (for example the
use of rtc's to get periodic timers, is clunky at best), much of the core
and the actual device drivers are to my mind pretty clean.  So the question
is, 'Is lack of reviewers a valid reason to submit to staging in the meantime?'

What do people think?

All offers of review or other suggestions on how to proceed also welcome!

Also I'm still not that keen on the name if anyone has a better idea.

Thanks

Jonathan
