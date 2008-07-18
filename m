Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbYGRMts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbYGRMts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbYGRMtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:49:41 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:13293 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbYGRMtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:49:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=LCUdBhh8pvWf8GeCparEKsAjUZcj2ZbN3Ropw5DaAgyNw93DvwgYjvjcwx+NpPupJ1
         v3hJyF7nUTPvsjP5T0vYwVUbACqs62fJZOyBgHyYYD2GhazM+fCwTWfU0HqnFmIoQ8Si
         6R1XUAVBsRldsi6/0zFHonStlIDnLWeAybiAk=
Message-ID: <9871ee5f0807180549l58e849d9ge6e7deee3d0c37fa@mail.gmail.com>
Date: Fri, 18 Jul 2008 08:49:38 -0400
From: "Timothy Normand Miller" <theosib@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Problem: Load average of 6, no I/O, 25% idle time. Why?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a four processor box, running three compute loads.  The kernel
I'm running is 2.6.25-gentoo-r5.

One process has four threads, and it's niced to 19.
Another process has one thread and is niced to -10
The last process has one thread and is niced to 0

One processor is always idle.

If I change either the 0 to a -10 or the -10 to a zero, then all four
cores are properly utilized.

Does this make sense to anyone?  Besides messing with the nice levels,
is there another way to fix this?

Thanks!

-- 
Timothy Normand Miller
http://www.cse.ohio-state.edu/~millerti
Open Graphics Project
