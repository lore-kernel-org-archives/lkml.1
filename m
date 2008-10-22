Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbYJVPol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbYJVPol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYJVPod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:44:33 -0400
Received: from dew2.atmos.washington.edu ([128.95.89.42]:47348 "EHLO
	dew2.atmos.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbYJVPoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:44:32 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 11:44:32 EDT
Message-ID: <48FF482F.5060002@atmos.washington.edu>
Date: Wed, 22 Oct 2008 08:35:11 -0700
From: Harry Edmon <harry@atmos.washington.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: SUNRPC problem with 2.6.26 and beyond
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -102.6 () BAYES_00,SPF_PASS,USER_IN_WHITELIST
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a dual quad-core Xeon system running software 
(http://www.unidata.ucar.edu/software/ldm) that relays and processes 
weather data through RPC calls, keeping a queue of data in a memory 
mapped file.  Up until 2.6.26 the system has run just fine (for example 
2.6.25.17).  But starting with 2.6.26 through 2.6.27.2 the system runs 
into a problem after approximately 24 hours.  The symptom is that the 
processing slows down to a crawl.  Using "top" I can see that the System 
time is up over 90%, with almost no User and Wait time.  If I stop and 
restart the software, most of the time it gets better - but sometimes it 
takes a reboot to fix the problem.  I have an identical system that does 
just processing and ingesting data from remote systems, and it does not 
have this problem.  I have tried a number of different kernel 
configurations, but they all show the same problem.

I suspect a problem with SUNRPC.  I notice that there were a large 
number of SUNRPC patches in 2.6.26.  I am looking for suggestions on how 
to pin down which patches are causing the problem.  Are there ways to 
figure where in the  kernel the time is being spent?  I am will to work 
on isolating the problem, but I need some suggestions on the best way to 
do it given the large number of SUNRPC patches in 2.6.26 and the fact 
that each experiment takes a day.
-- 

 Dr. Harry Edmon			E-MAIL: harry@atmos.washington.edu
 206-543-0547				harry@washington.edu
 Dept of Atmospheric Sciences		FAX:	206-543-0308
 University of Washington, Box 351640, Seattle, WA 98195-1640

