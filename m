Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbXK3ToU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbXK3ToU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbXK3ToB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:44:01 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:55508 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbXK3ToA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:44:00 -0500
Date: Fri, 30 Nov 2007 14:41:34 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, "Serge E. Hallyn" <serue@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: capabilities-introduce-per-process-capability-bounding-set.patch breaks FC6 Avahi
Message-ID: <20071130194134.GA7536@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

avahi-daemon fails to start on FC6 when
capabilities-introduce-per-process-capability-bounding-set.patch is
applied.

strace shows
	capset(0x19980330, 0, {CAP_SETGID|CAP_SETUID|CAP_SYS_CHROOT, CAP_SETGID|CAP_SETUID|CAP_SYS_CHROOT, 0}) = -1 EPERM (Operation not permitted)

I don't know if this is expected, but the changelog doesn't seem to
imply that this will break things.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
