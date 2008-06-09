Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbYFIGEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbYFIGEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 02:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbYFIGE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 02:04:26 -0400
Received: from 202.54.90.7.ill-bgl.static.vsnl.net.in ([202.54.90.7]:36395
	"HELO 202.54.90.7.ill-bgl.static.vsnl.net.in"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751743AbYFIGEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 02:04:25 -0400
X-Greylist: delayed 21422 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2008 02:04:24 EDT
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: mmc_test : some results
Content-class: urn:content-classes:message
Date: Mon, 9 Jun 2008 05:51:52 +0530
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <5BF78BCE8D9BF14A83F836BD9E3916BA0DDFC3@blrms.slti.sanyo.co.in>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: mmc_test : some results
Thread-Index: AcjH7WV3VtVQWbJ0T7eJ2eWYrn02CgCW4TOw
References: <48495843.1050902@atmel.com>
From: "Gururaja Hebbar K R" <gururajakr@sanyo.co.in>
To: "Nicolas Ferre" <nicolas.ferre@atmel.com>,
       "Pierre Ossman" <drzeus@drzeus.cx>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

Could you please be kind enough to share the test program so that we can
test mmc driver on other platforms.

 i have a customized arm9 versatile board with mmci controller and
would like to test the same

TIA,

Regards
Gururaja


-----Original Message-----
From: linux-arm-kernel-bounces@lists.arm.linux.org.uk
[mailto:linux-arm-kernel-bounces@lists.arm.linux.org.uk] On Behalf Of
Nicolas Ferre
Sent: Friday, June 06, 2008 8:31 AM
To: Pierre Ossman; ARM Linux Mailing List; Linux Kernel list
Subject: mmc_test : some results

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


-------------------------------------------------------------------
List admin:
http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
