Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbXH1OUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbXH1OUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 10:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbXH1OUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 10:20:37 -0400
Received: from host-66-43-248-10 ([67.55.143.10]:34794 "EHLO albrecht.rdi1.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755313AbXH1OUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 10:20:00 -0400
Subject: dm-crypt mount returns EINVAL
From: Paul Albrecht <albrecht@rdi1.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: albrecht@rdi1.com
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Aug 2007 09:24:25 -0400
Message-Id: <1188307465.2653.12.camel@albrecht.rdi1.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have recently upgraded my kernel to 2.6.21 from 2.6.20 and that has
caused a problem mounting an encrypted partition using dm-crypt.

In my init script, I use cryptsetup to create device which I use to
mount an encrypted partition. Since I changed to 2.6.21 the mount fails
returning an EINVAL status which doesn't make much sense because the
init script is unchanged and works if reverted to 2.6.20.

Any ideas? How can I debug this problem? I'm not subscribed to lkml so
please cc in your response.

Paul Albrecht
