Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbXK1EhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbXK1EhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 23:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbXK1EhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 23:37:04 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:51051 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195AbXK1EhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 23:37:01 -0500
Message-ID: <474CF06C.8020208@lwfinger.net>
Date: Tue, 27 Nov 2007 22:37:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Question regarding mutex locking
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If a particular routine needs to lock a mutex, but it may be entered with that mutex already locked,
would the following code be SMP safe?

hold_lock = mutex_trylock()

...

if (hold_lock)
	mutex_unlock()

Thanks,

Larry
