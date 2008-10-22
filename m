Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbYJVNj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbYJVNj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 09:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYJVNje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 09:39:34 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:63948 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbYJVNjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 09:39:33 -0400
From: hooanon05@yahoo.co.jp
To: ttb@tentacle.dhs.org, rml@novell.com
cc: linux-kernel@vger.kernel.org
Subject: lock free inotify_ioctl()?
Date: Wed, 22 Oct 2008 22:39:30 +0900
Message-ID: <7353.1224682770@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello John McCutchan and Robert Love,

I have a question about inotify_ioctl().
I am investigating if a user process misses the inotify event or gets
wrong event by ioctl(fd, FIONREAD, &pending) in linux-2.6.27, and found
it doesn't acquire dev->ev_mutex lock before accessing dev->queue_size.

In SMP system, is it safe and sure too?
Is the mutex lock unnecessary?


Junjiro R. Okajima
