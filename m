Return-Path: <linux-kernel-owner+w=401wt.eu-S1751603AbZHKLyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbZHKLyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZHKLyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:54:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:37431 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbZHKLyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:31 -0400
Message-Id: <20090811110902.255877673@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Tue, 11 Aug 2009 21:09:02 +1000
From: npiggin@suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: [patch 0/4] ipc sem improvements
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this patchset is some improvements I've been trying to make to sysv
semaphore implementation which is pretty suboptimal (O(n^2) behaviour
with n waiting processes, among other things).

I've been quite careful to try retaining fifo and avoiding starvation
even for complex operations.

Comments?

Thanks,
Nick

