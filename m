Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbYFFPbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbYFFPbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760292AbYFFPbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:31:22 -0400
Received: from mail.atmel.fr ([81.80.104.162]:62713 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760153AbYFFPbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:31:21 -0400
Message-ID: <48495843.1050902@atmel.com>
Date: Fri, 06 Jun 2008 17:31:15 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Marc Pignat <marc.pignat@hevs.ch>
Subject: mmc_test : some results
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

Here are the results of a mmc_test run played on at91_mci after applying 
this patch series :
http://lkml.org/lkml/2008/5/30/201

I skipped some of the tests just to concentrate on those ones.

Can you tell me if the test is correct : are the errors reported for the 
xfer_size tests the normal behavior (I assume yes because a failure is 
simulated) ?

~ # echo 1  > /sys/class/mmc_host/mmc0/mmc0\:e624/test
mmc0: Starting tests of card mmc0:e624...
mmc0: Test case 1. Basic write (no data verification)...
mmc0: Result: OK
mmc0: Test case 2. Basic read (no data verification)...
mmc0: Result: OK
mmc0: Test case 3. Basic write (with data verification)...
mmc0: Result: OK
mmc0: Test case 4. Basic read (with data verification)...
mmc0: Result: OK
mmc0: Test case 5. Multi-block write...
mmc0: Result: OK
mmc0: Test case 6. Multi-block read...
mmc0: Result: OK
mmc0: Test case 7. Correct xfer_size at write (start failure)...
mmc0: Result: ERROR (-84)
mmc0: Test case 8. Correct xfer_size at read (start failure)...
mmc0: Result: ERROR (-110)
mmc0: Test case 9. Correct xfer_size at write (midway failure)...
mmc0: Result: ERROR (-84)
mmc0: Test case 10. Correct xfer_size at read (midway failure)...
mmc0: Result: ERROR (-110)
mmc0: Tests completed.
~ #

Thanks, regards,
-- 
Nicolas Ferre

