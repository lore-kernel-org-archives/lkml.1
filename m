Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbXICR5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbXICR5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 13:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbXICR5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 13:57:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:62262 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbXICR5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 13:57:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dl9eL39T8XMw74sxdCLh+cA5H6SruI3oG7IrE1ClmBPMMjzkokcviTlWLP7++aVVST7JUC8dCbSFVkpSIxU3d3Bp1vEF/V6ZTeNL/yC5PBOfnK5zUrF9KfYqzijuKPFA503z0CihPhLZTJ3H/ZFNgCD/xrLoHlzI00O991ZhMxQ=
Message-ID: <ab40e9c0709031057y195467c7y63f74b753218b618@mail.gmail.com>
Date: Mon, 3 Sep 2007 19:57:06 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: mutex vs cache coherency protocol(for multiprocessor )
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

Just got a rough question in my head.

don't know whether anyone interested .

mutex vs cache coherency protocol(for multiprocessor)

both of these two can be used to protect shared resource in the memory.

are both of them necessary?

for example:

in a multiprocessor system, if there is only mutex no cache coherency.
obviously this would cause problem.

what about there is no mutex mechanism, only cache coherency protocol
in multiprocessor system? after consideration, I found this also could
casue problem, when the processors are multithreading processors,
which means more than one threads can be running on one processor. in
this case if we only have cache coherency and no mutex, this would
cause problem. because all the threads running on one processor share
one cache, the cache coherency protocol can not be functioning
anymore. the shrared resource could be crashed by different threads.

then if all the processors in the multiprocessor system are sigle
thread processor, only one thread can be running one one processor. is
it ok, if we only have cache coherency protocol ,no mutex mechanism?

anyone has any idea? all the comments are welcome and appreciated,
including criticism.

regards,
