Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbXJCCne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbXJCCne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 22:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbXJCCn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 22:43:27 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:3400 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbXJCCn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 22:43:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=IoS/h/ojBn9/ACQA+SCzyAoz+6ccm6MVCbJMYYmygtP0qNGdgcJ3MoyzpY6piRqHSe7GjVIWXdlhZ9VSRwKZxSrX8Si0fXXtxA/RqBPy99f6KjDK9UTC5FulUAsf3X6TsvyelwqA5GK+nCe9JSUPRvzc8Z4D+qfcC19kHfWcKpo=
Message-ID: <9dbec86d0710021943n5028e6c1v56b22ade907b8098@mail.gmail.com>
Date: Wed, 3 Oct 2007 10:43:24 +0800
From: Sonny <smaniaol@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Traffic Controller Performance in Kernel 2.4 vs 2.6
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello
This is a repost, there seems to have a misunderstanding before.

I hope this is the right place to ask this. Does any know if there is a
substantial difference in the performance of the traffic controller
between kernel 2.4 and 2.6. We tested it using 1 iperf server and use
250 and 500 clients, altering the burst.

This is the set-up:
iperf client -  router (w/ traffic controller) - iperf server

We use the top command inside the router to check the idle time of our
router to see this. The results we got from the 2.4 kernel shows
around 65-70% idle time while the 2.6 shows
60-65% idle time. We tried to use MRTG and we're not getting any
results either. We want to know if we could improve the bandwidth by
upgrading the kernel, else we would have to get a new bandwidth
manager.  Have anyone performed a similar test or can suggest a better
way to do this. Thanks in advance.
