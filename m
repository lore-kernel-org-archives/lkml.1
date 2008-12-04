Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbYLDPUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbYLDPUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYLDPU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:20:29 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:11898 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbYLDPU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:20:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition;
        b=ELLa0qpOw/ssncF5WRA/rHAkB+oeDwP1ivdq7f1haBjRkSB66NeiIBP6S6Iebdw1k8
         leCVaZOdmPKVXvMNga4R5n5sCyM0WcQ5jnRkrcmXeXf/bWfL2Y0IJx+NL64bIxla97gs
         VG1RLXb6vaw2AAqNjfMMVeQlcJDbipFZD4Xas=
Message-ID: <cfd18e0f0812040720y5cabd2aarbf3912644dea42c4@mail.gmail.com>
Date: Thu, 4 Dec 2008 10:20:26 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Could you write some CLONE_NEWUSER?
Cc: ebiederm@xmission.com, lkml <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org, clg@fr.ibm.com, herbert@13thfloor.at,
       dev@sw.ru, "Subrata Modak" <subrata@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Serge,

Thanks for CCing me on recent CLONE_NEWUSER patches.

Would you be will to write some documentation for this flag?  (It's
the only remaining undocumented flag in clone(2).)  Plain text would
be fine -- I'll integrate it into the man page with suitable macros.

Cheers,

Michael


---------- Forwarded message ----------
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Date: Wed, Nov 19, 2008 at 3:04 PM
Subject: Current state of CLONE_NEWUSER?
To: Serge Hallyn <serue@us.ibm.com>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>, ebiederm@xmission.com,
lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
clg@fr.ibm.com, herbert@13thfloor.at, dev@sw.ru


Hi Serge,

What is the current status of CLONE_NEWUSER?  I'm currently trying to
test this flag in preparation for documenting it in the clone(2) man
page, but am running into an ENOMEM error from the clone() call, which
seems to occur after a failure in kobject_init_and_add() in the
following call sequence:

clone_user_ns() --> alloc_uid() --> uids_user_create() -->
kobject_init_and_add()

Are there already some test programs somewhere?  Is there any
documentation already available for this flag?

Thanks,

Michael

--
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
