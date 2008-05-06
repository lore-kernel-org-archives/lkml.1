Return-Path: <linux-kernel-owner+w=401wt.eu-S932292AbYEFQFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbYEFQFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765071AbYEFQCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:02:49 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:7350 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764675AbYEFQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:02:42 -0400
Message-Id: <20080506155027.974409738@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 May 2008 17:50:27 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch 0/8] s390 patches for 2.6.26-rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current s390 patch queue for 2.6.26-rc1. The most interesting patch
is the guest page hinting patch for unused pages. It is purely s390 so
it should be fine to push this even after -rc1, no?

Christian Borntraeger (1):
      [S390] s390-kvm: leave sie context on work. Removes preemption requirement

Heiko Carstens (1):
      [S390] tty3270: fix put_char fail/success conversion.

Martin Schwidefsky (3):
      [S390] s390: Optimize user and work TIF check
      [S390] s390mach compile warning
      [S390] guest page hinting light

Michael Ernst (2):
      [S390] cio: Remove cio_msg kernel parameter.
      [S390] cio: Fix parsing mechanism for blacklisted devices.

Roland McGrath (1):
      [S390] compat ptrace cleanup

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

