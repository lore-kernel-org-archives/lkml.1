Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbZHLPxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbZHLPxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZHLPxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:53:11 -0400
Received: from kroah.org ([198.145.64.141]:58333 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbZHLPxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:53:10 -0400
Date: Wed, 12 Aug 2009 08:51:01 -0700
From: Greg KH <greg@kroah.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Merge strategy for Industrial I/O (staging?)
Message-ID: <20090812155101.GA30629@kroah.com>
References: <4A828AE9.9090807@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A828AE9.9090807@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 09:27:05AM +0000, Jonathan Cameron wrote:
> Dear All,
> 
> IIO is intended to be a subsystem for sensors such as ADCs, accelerometers,
> gyros, light sensors and others that have reasonably high update rates and
> typically are connected via i2c or spi busses.
> 
> The latest patch set posted to lkml was v4
> http://thread.gmane.org/gmane.linux.kernel/860693
> Tree at 
> http://git.kernel.org/?p=linux/kernel/git/jic23/iio_v4.git;a=summary
> 
> original discussion of the need for such a subsystem:
> http://lkml.org/lkml/2008/5/20/135
> 
> The last couple of versions of IIO have recieved some useful feedback from
> a number of people, and feedback from various users has led to a number
> of recent bug fixes.  Unfortunately, full reviews of any given element have
> not be forthcoming.  Several people who have in principle offered to help
> haven't had the time as yet.
> 
> In the short term, the lack of review of the core (patch 1 of the above set)
> leads to a stack of device drivers sitting in the git repository waiting on
> the core being merged. Currently in the tree there are 3 acceleromters, an
> adc and a light sensor.  I also have an IMU driver (ADIS16350 family) that
> needs a little more cleaning up and testing with latest IIO core.
> 
> Increasing numbers of drivers that would fall within the scope of IIO are
> being submitted to various other subsystems (hwmon for example) and getting
> bounced out as inappropriate for that subsystem.  So, whilst I'd be reasonably
> happy to maintain the subsystem out of kernel until interest in the devices
> covered grows, or people have time to assist, I was wondering whether it
> would be appropriate to submit the subsystem and the associated driver
> set to staging.
> 
> Whilst some elements could definitely do with more work (for example the
> use of rtc's to get periodic timers, is clunky at best), much of the core
> and the actual device drivers are to my mind pretty clean.  So the question
> is, 'Is lack of reviewers a valid reason to submit to staging in the meantime?'

Yes, I have no objection to taking these patches in staging for now, as
long as you submit it with a TODO list of things left to be done to get
it merged to the main portion of the kernel tree.

So, send me the patches!

thanks,

greg k-h
