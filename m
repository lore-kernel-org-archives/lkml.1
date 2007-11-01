Return-Path: <linux-kernel-owner+w=401wt.eu-S1759073AbXKATzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbXKATzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 15:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759427AbXKATyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 15:54:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:58246 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194AbXKATyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 15:54:46 -0400
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andrew Morgan <morgan@kernel.org>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Chris Wright <chrisw@osdl.org>
Subject: Re: [PATCH] 2.6.23: Filesystem capabilities 0.17
References: <871wbhc0zj.fsf@olafdietsche.de>
	<20071031173606.GA27982@vino.hallyn.com>
From: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Date: Thu, 01 Nov 2007 20:54:09 +0100
Message-ID: <87mytx91y6.fsf@olafdietsche.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1+zxefaOS3R30IWfNetFQg29VYE+8Qz5Qe+gtz
 TXxU46hRu3i5AiIZ2Y7yeUlotk+8IOj4aZ1iyP9PzGrVx2gZ+e
 XcU6KEGZRNoxFiPgCIoRA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Olaf Dietsche (olaf+list.linux-kernel@olafdietsche.de):
>> This patch implements filesystem capabilities. It allows to
>> run privileged executables without the need for suid root.
>> 
>> Changes:
>> - updated to 2.6.23
>> - fix const correctness
>> - fix secureexec
[...]
> given that file capabilities are now in 2.6.23, could you explain the
> benefits of this version?  Should we consider switching it out for
> yours?

It's just another version, works without xattr and, most important:
it's mine :-)

> If we stick with the current upstream file capabilities patch, should we
> port your SECURE_HACK to it?  I actually thought that fixing
> bprm_secure_exec() sufficed?

Fixing bprm_secure_exec() is sufficient. SECURE_HACK is just a
leftover, when there was no AT_SECURE and accordingly libc (< 2.3.6)
ignored bprm_secure_exec().

Regards, Olaf.
