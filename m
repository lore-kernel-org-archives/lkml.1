Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbXDTBLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbXDTBLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 21:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbXDTBLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 21:11:52 -0400
Received: from mail03.syd.optusnet.com.au ([211.29.132.184]:44002 "EHLO
	mail03.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754387AbXDTBLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 21:11:51 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: rr_interval experiments
Date: Fri, 20 Apr 2007 10:47:57 +1000
User-Agent: KMail/1.9.5
Cc: ck list <ck@vds.kolivas.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <npiggin@suse.de>
References: <200704200101.49823.kernel@kolivas.org>
In-Reply-To: <200704200101.49823.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704201047.57539.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2007 01:01, Con Kolivas wrote:
> This then allows the maximum rr_interval to be as large as 5000
> milliseconds.

Just for fun, on a core2duo make allnoconfig make -j8 here are the build time 
differences (on a 1000HZ config) machine:

16ms:
53.68user 4.81system 0:34.27elapsed 170%CPU (0avgtext+0avgdata 0maxresident)k

1ms:
56.73user 4.83system 0:36.03elapsed 170%CPU (0avgtext+0avgdata 0maxresident)k

5000ms:
52.88user 4.77system 0:32.37elapsed 178%CPU (0avgtext+0avgdata 0maxresident)k

For the record, 16ms is what SD v0.43 would choose as the default value on 
this hardware. A load with a much lower natural context switching rate than a 
kernel compile, as you said Nick, would show even greater discrepancy in 
these results.

Fun eh? Note these are not for any comparison with anything else; just to show 
the effect rr_interval changes have on throughput.

-- 
-ck
