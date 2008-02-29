Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbYB2OQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbYB2OQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbYB2OQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:16:50 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:40765 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbYB2OQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:16:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=aJAoAJVpY9LNmGvB+Ba8tWCRD4Z7WMEB5GYWzjCPcH/hmTy3HbgJqZOKijoqMdNuoz54VKCEIgvsUrOrrgb+QtdiQfGjYU2fxW2n7PRgUuYdazWcWRIRItmilrRDrCzQNGH/lHpEE+9Ng/WQ7XW7x8Xv3hVGvkPmYEtJ3LWQ158=
Message-ID: <74d8fc520802290616w36a245e5qa851ad2f0b068472@mail.gmail.com>
Date: Fri, 29 Feb 2008 14:16:48 +0000
From: "Gordon Mckeown" <ml_lkml@thefluffyone.net>
To: linux-kernel@vger.kernel.org
Subject: Very high IOWait during all disk activity
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: ed08b181dc7e59a2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please cc me on replies)

I recently noticed on a number of my Linux boxes that during disk
activity, CPU usage was consistently hitting 100%. A little digging
showed that the CPU was spending up to around 65% of its time in an
IOWait state. Checked this with kernels 2.6.22 and 2.6.25-rc3, and
also across SATA and PATA drives on three different machines, all with
the same results. I also checked back with an old Ubuntu 6.06 Live CD
and that also exhibits the problem.

Having done some digging on the net, I can't get a definitive answer
as to whether this is considered "normal". Some people suggest that
IOWait is informational and doesn't indicate a problem, but based on
my admittedly limited understanding of such things, the CPU shouldn't
need to spend much time on disk I/O these days due to the use of DMA.

Is it expected behaviour for the CPU to spend such a large amount of
time in the IOWait state during disk I/O?

(For anyone who wants to see a more detailed analysis, I have an open
bug on Ubuntu's Launchpad: https://bugs.launchpad.net/bugs/192353).

Cheers,

Gordon.
