Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbZA3Vz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbZA3Vz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 16:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbZA3Vzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 16:55:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:24804 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbZA3Vzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 16:55:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GKrjc5RPV9RFtj21u5fhdrq99pbO/ajmv8ePNzaMq/JxEiPsii1MrwTJCN9KYp7vkQ
         ipFEyOIb0ta5yEWbSdZbR12qvqy2YXrhVYUbQnNsOgw+gFCVpWjeVn0CjDZRPB4DWEwt
         9uMvgcwlB5axe1d/y5H3kFyT6/VVclO+kYcPo=
MIME-Version: 1.0
Date: Fri, 30 Jan 2009 22:55:47 +0100
Message-ID: <4dcf7d360901301355l7ed26a5aob7ef6d79d9607b6b@mail.gmail.com>
Subject: SSD and IO schedulers
From: Lorenzo Allegrucci <l.allegrucci@gmail.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I was wondering how IO schedulers such as as-iosched, deadline and
cfq behave on SSD
(that have virtually no seek time), from a theoretical point of view.
How do they affect
performance on these devices?
I heard that the noop scheduler is often chosen by owners of EeePcs
(with a SSD unit).
They report superior performance by using this (quite simple) scheduler.
Are there any scientific benchmarks around?

-- 
Lorenzo
