Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbYHaBZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbYHaBZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 21:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbYHaBZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 21:25:17 -0400
Received: from web82104.mail.mud.yahoo.com ([209.191.84.217]:41021 "HELO
	web82104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754239AbYHaBZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 21:25:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=Xnsan++9uY34yJBVgzhVf3eY7BwU412yiDX9XTD6MgFF+KWOEBTB0EjHNIC6BY8cUwYRxgIWFGBo1rn2/Bl+FohxyqGSpvetuEzhJ5xZhSZ4JhSSNXJw2glU3WVzazVpcoUNClw+q/3Jywydr9hBbT3Wt+NQv9LQZ7s6jeCQJUE=;
X-YMail-OSG: Q01mzL0VM1kf57NA7oT2tR0vk6m5V.FUMQF2nyypCVW.yv05qgpFS.F_SVE.qQmVew--
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218.2
Date: Sat, 30 Aug 2008 18:25:14 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <349034.72587.qm@web82104.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> please use split_e820_reserve_xx2.patch instead...

OK, that produces the same result:  a happy kernel!

I compared the full 'dmesg' output from the previous build and the
current build using diff:  the only differences were trivial --
return times from initcall functions, and the order in which some
initcalls were performed was different very late in the boot process.


Thanks Yinghai,
Dave W.
