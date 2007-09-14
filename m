Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbXINKa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbXINKa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 06:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbXINKaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 06:30:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53091 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbXINKaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 06:30:14 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: O_NOLINK for open()
To: Brent Casavant <bcasavan@sgi.com>, Gabor Gombas <gombasg@sztaki.hu>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Fri, 14 Sep 2007 12:30:05 +0200
References: <92Haf-7z7-5@gated-at.bofh.it> <92TO5-246-1@gated-at.bofh.it> <92Zqu-2ur-1@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IW8R4-0000ko-2z@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18QKouEpooXVHn/tLkcgF2tuJwK5WUOdktLJIz
 v29z2qY+aypaXsqdOWqPSrNvYe0fKAxaQAuFIbMKOm58aiFM2E
 eO7eq/IeV81eRy3tBLesw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brent Casavant <bcasavan@sgi.com> wrote:

[...]
> Hmm.  This will work as long as the peer process is running setuid
> to it's own unique user.  Excellent idea!  Since I need to make the
> program setuid to avoid non-priveleged ptrace attacks, this is a
> terrific solution.

Tried that:

~ > cd tmp
~/tmp > cp /bin/sleep .
~/tmp > chmod u+s sleep
~/tmp > ./sleep 2147483647 &
[1] 2823
~/tmp > strace -p 2823
Process 2823 attached - interrupt to quit
setup(

-- 
Top 100 things you don't want the sysadmin to say:
27. You can do this patch with the system up...

Friﬂ, Spammer: 7TdJfPsslN@y4jaOy.7eggert.dyndns.org
