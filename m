Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbZHLQJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbZHLQJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbZHLQJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:09:09 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:35624 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbZHLQJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:09:08 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A8294DD.3080205@cam.ac.uk>
Date: Wed, 12 Aug 2009 10:09:33 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Merge strategy for Industrial I/O (staging?)
References: <4A828AE9.9090807@cam.ac.uk> <20090812155101.GA30629@kroah.com>
In-Reply-To: <20090812155101.GA30629@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Aug 12, 2009 at 09:27:05AM +0000, Jonathan Cameron wrote:
>> Dear All,
>>
>> IIO is intended to be a subsystem for sensors such as ADCs, accelerometers,
>> gyros, light sensors and others that have reasonably high update rates and
>> typically are connected via i2c or spi busses.
>>
>> The latest patch set posted to lkml was v4
>> http://thread.gmane.org/gmane.linux.kernel/860693
>> Tree at 
>> http://git.kernel.org/?p=linux/kernel/git/jic23/iio_v4.git;a=summary
>>
>> original discussion of the need for such a subsystem:
>> http://lkml.org/lkml/2008/5/20/135
>>
>> The last couple of versions of IIO have recieved some useful feedback from
>> a number of people, and feedback from various users has led to a number
>> of recent bug fixes.  Unfortunately, full reviews of any given element have
>> not be forthcoming.  Several people who have in principle offered to help
>> haven't had the time as yet.
>>
>> In the short term, the lack of review of the core (patch 1 of the above set)
>> leads to a stack of device drivers sitting in the git repository waiting on
>> the core being merged. Currently in the tree there are 3 accelerometers, an
>> adc and a light sensor.  I also have an IMU driver (ADIS16350 family) that
>> needs a little more cleaning up and testing with latest IIO core.
>>
>> Increasing numbers of drivers that would fall within the scope of IIO are
>> being submitted to various other subsystems (hwmon for example) and getting
>> bounced out as inappropriate for that subsystem.  So, whilst I'd be reasonably
>> happy to maintain the subsystem out of kernel until interest in the devices
>> covered grows, or people have time to assist, I was wondering whether it
>> would be appropriate to submit the subsystem and the associated driver
>> set to staging.
>>
>> Whilst some elements could definitely do with more work (for example the
>> use of rtc's to get periodic timers, is clunky at best), much of the core
>> and the actual device drivers are to my mind pretty clean.  So the question
>> is, 'Is lack of reviewers a valid reason to submit to staging in the meantime?'
> 
> Yes, I have no objection to taking these patches in staging for now, as
> long as you submit it with a TODO list of things left to be done to get
> it merged to the main portion of the kernel tree.
> 
> So, send me the patches!
Will do, thanks.

Jonathan

