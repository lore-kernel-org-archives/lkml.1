Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051Ab0AaAgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0AaAgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 19:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121Ab0AaAgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 19:36:53 -0500
Received: from mail-qy0-f200.google.com ([209.85.221.200]:44164 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab0AaAgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 19:36:52 -0500
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jan 2010 19:36:52 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=G1hW0REcuyPVHUGkscTp1UEN5NRmZjMPwxvfGnEnle0N9xUTA7zeqaMct+Jiy9glrc
         0emr8qgK0+Lo72NbDZWJHOzff60PfBwkZEo2kckgRwZRINB5v0Kh0qeDu96E5mFaypnJ
         hPnzwyuhQNWDyRATvaKXjgeHcR4a38vD51DLE=
Subject: Re: Radeon KMS regression still present in 2.6.33-rc6
From: Kevin Winchester <kjwinchester@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
       Dave Airlie <airlied@linux.ie>, dri-devel <dri-devel@lists.sf.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Jerome Glisse <jglisse@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       John Kacur <jkacur@gmail.com>
In-Reply-To: <alpine.LFD.2.00.1001301153390.4206@localhost.localdomain>
References: <1264871899.1533.6.camel@localhost.localdomain>
	 <alpine.LFD.2.00.1001300929260.4206@localhost.localdomain>
	 <201001302050.11897.johannes.hirte@fem.tu-ilmenau.de>
	 <alpine.LFD.2.00.1001301153390.4206@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jan 2010 20:29:41 -0400
Message-ID: <1264897781.1528.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-30 at 11:54 -0800, Linus Torvalds wrote:
> 
> On Sat, 30 Jan 2010, Johannes Hirte wrote:
> > 
> > This is caused by commit 42590a75019a50012f25a962246498dead42843
> > 
> > Fix is already posted:
> > 
> > http://marc.info/?l=linux-kernel&m=126428141429200&w=2
> 
> Goodie. Kevin, can you test the patch from FUJITA Tomonori in that thread 
> ("http://marc.info/?l=linux-kernel&m=126439631307219&w=2" to be exact).
> 

Thank you - the patch from FUJITA Tomonori corrected the issue.

I also tried out the additional patches from John Kacur.  They did not
break anything that I could see, and the logic behind them seems
reasonable to me.  They weren't necessary to fix my problem though, so I
guess they are likely not 2.6.33 material (unless they are critical for
someone else).

Thanks again to everyone who looked into the problem,

-- 
Kevin Winchester



