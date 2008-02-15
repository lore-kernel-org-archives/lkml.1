Return-Path: <linux-kernel-owner+w=401wt.eu-S1765591AbYBOLoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765591AbYBOLoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 06:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYBOLoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 06:44:03 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44298 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYBOLoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 06:44:01 -0500
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, jdike@addtoit.com, jack@suse.cz
Subject: 2.6.24-mm1 bugs
Message-Id: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 15 Feb 2008 12:43:45 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying out 2.6.24-mm1 on my work laptop (T60), and generally it
works surprisingly well (including suspend/resume), with only a few
minor issues.  If these are not known/fixed already, I'll send out
proper bug reports to the relevant people:

 - UML doesn't boot: guest is 2.6.24-mm1 also, haven't tried any
   other.  Same guest boots fine on 2.6.24 host.

 - mounting isofs always results in an empty directory

 - network doesn't always come up at first try (e1000e).  On 2.6.24
   e1000e doesn't seem to work at all, so I use e1000, but that has
   other problems.

 - strange key repeating (short press of a key results in lots of key
   press events) when there's some sort of load (I/O?)  I may have
   seen this on non-mm kernels as well, but it's definitely more
   noticable in -mm

Thanks,
Miklos
