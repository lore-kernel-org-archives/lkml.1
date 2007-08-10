Return-Path: <linux-kernel-owner+w=401wt.eu-S1758931AbXHJWCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931AbXHJWCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbXHJWAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:00:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXHJWAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:00:07 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com
Subject: [PATCH 0/25 -v2] paravirt_ops for x86_64, second round
Date: Fri, 10 Aug 2007 16:12:12 -0300
Message-Id: <1186773157329-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is an slightly updated version of the paravirt_ops patch.
If your comments and criticism were welcome before, now it's even more!

There are some issues that are _not_ addressed in this revision, and here
are the causes:

* split debugreg into multiple functions, suggested by Andi:
  - Me and jsfg agree that introducing more pvops (specially 14!) is
    not worthwhile. So, although we do can keep one pvops function and turn
    the set/get debugreg macros into multiple ones, this is a general kernel
    issue, and can be addressed by a later patch.

* 2MB pages, and other functions that lives in pgalloc.h in the i386 version
  - As xen is the main user of it (i.e., lguest does not), we'd prefer to
    see an implementation of it from xen folks, or any other that understand
    it better. This way we don't delay the merge process of the
    already-written chunk. On the contrary, it will be easier to get that,
    as it will be smaller

If you addressed some concern before that is _not_ covered in this revision,
so it is my fault. Please fell free to voice it

Have fun!
