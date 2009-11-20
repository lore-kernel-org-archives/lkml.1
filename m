Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZKTOGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZKTOGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 09:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbZKTOG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 09:06:29 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:35498 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbZKTOG2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 09:06:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=qMGuc7kCGHc6eYrVMsSJoWFHyObroLU0v7jjBzpZT8UC4BG91ZG3ycR4BA7P8vMMpH
         4hEGb9cwnUre4HlgxMjtBao4u3F5zf5+/mcmfbOBdmTAgYZ7DG9H64HZAqdtwlAgNDPY
         Wy7Qk+3pXEnraic+0k3+NjGlU2YVYafTtamt0=
MIME-Version: 1.0
Date: Fri, 20 Nov 2009 09:06:33 -0500
Message-ID: <2aa71ac70911200606tdf97f3lbc718046ca14d332@mail.gmail.com>
Subject: Measuring page faults
From: Mike Gagnon <mikegagnon@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I would like to measure the latency (execution time) of Linux page
faults.  I tried using lmbench, but I get unrealistically fast results
from the lmbench lat_pagefault benchmark.  The problem seems to be
that lmbench attempts to ensure pages are paged out using msync with
the MS_INVALIDATE flag set, but this doesn't seem to cause page outs
on Linux.  http://www.bitmover.com/lmbench/lat_pagefault.8.html

I would like to adapt lmbench to correctly measure page faults on
Linux, but I need a mechanism to ensure specific pages are paged-out.
Is there a good way to reliably cause page-outs in Linux (so that I
may then cause page faults by touching the paged-out pages)?

Thanks,
Michael Gagnon
