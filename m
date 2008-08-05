Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbYHEOOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbYHEOOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbYHEOOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:14:22 -0400
Received: from web82102.mail.mud.yahoo.com ([209.191.84.215]:35776 "HELO
	web82102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754082AbYHEOOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:14:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=iRLeEfxsaVf6JfpOTlh4AcpDVw9b36EidaJk+evzInePHXMthYxwxJhKes+w5rUS+PzRQvTLEuGfj/60mt4fXhcvk8fMwdwnL8BXVp8RYLkgGbjF9eKmBmR+fXInUOrA8KC9x+YizGYeLwRR1uQoFppBSPx85gMA1VQ7V25ELz4=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Tue, 5 Aug 2008 07:14:20 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <876206.46405.qm@web82102.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Since you have that git tree, could you try to see if the latest -git
> still has this problem?

  I had forgotten to do that at the time I posted.

  Last night, after the post, I _did_ try building "master".  The commit
date was from Aug. 1 -- I am at work right now, so I can't provide exact
info until I get home in about 6 hours.  I checked 'Makefile', and the
version there was 2.6.27-rc1, IIRC.
  It built fine, but same freeze was seen.

  A reversion of the commit I mentioned _will_ solve the problem, but
looking at the code I saw that it was an attempt to provide better
functionality.  I'm willing to help test modifications to make the new
code work!


Thanks,
Dave W.
