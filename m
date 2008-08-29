Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbYH2TA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbYH2TA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 15:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbYH2TAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 15:00:46 -0400
Received: from web82104.mail.mud.yahoo.com ([209.191.84.217]:44024 "HELO
	web82104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752765AbYH2TAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 15:00:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=hnbFsoAW1SAzlUdw6nT1tgX0f4ir5+CggeK5x4c3k/CQV7Z1VFk90ZuwhNPXvPMsUnYblGdxvvtcCH/XDM9uaNMLbFEUijhmDsPBX1izAwGhex4YyCfoFyZPnUEQXNG/fIB92VcbwS5dBm70qbuz4O8e19tO2Ci5VRuTo+wrU3A=;
X-YMail-OSG: NRMVDvsVM1mwmSn0oBtvB2SZ9wVuIEwkEpePpgO0UNi1mRiLNtwc.gco0n5zDgzBEXQLyCMRpCKvfbqv7HWUFgmtePPgxfNxO0kjEJlwVDlqDjpdbnoL3olxxgnjN64-
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218.2
Date: Fri, 29 Aug 2008 12:00:45 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v2
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <779431.38300.qm@web82104.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> can you check tip/master now? Ingo fixed it arlready...

Yinghai,

Before updating my git tree, I copied some files (in their 
respective directories):

e820.c ==> e820.c.yh
i386.c ==> i386.c.yh
e820.h ==> e820.h.yh


Then I updated and checked out tip/master:

git remote update
git checkout -f tip/master


Running diffs on the updated files and the old files with your 
patches (i.e., 'diff e820.c{,.yh}') confirmed that the files
were the same.

However, for the sake of paranoia prevention, I went ahead and
built the kernel and rebooted:  it worked perfectly.


Thx,
Dave W.
