Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbYCZL7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbYCZL7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbYCZL7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:59:14 -0400
Received: from lazybastard.de ([212.112.238.170]:59556 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbYCZL7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:59:13 -0400
Date: Wed, 26 Mar 2008 12:58:53 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, apw@shadowen.org, jirislaby@gmail.com,
       viro@ZenIV.linux.org.uk, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups - formatting only
Message-ID: <20080326115853.GE22847@logfs.org>
References: <20080326102654.GB22847@logfs.org> <20080326112311.GG17176@elte.hu> <20080326114142.GD22847@logfs.org> <20080326.044802.107678511.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080326.044802.107678511.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 March 2008 04:48:02 -0700, David Miller wrote:
> 
> > Do you have a non-consistency based reason to prefer the longer
> > version?
> 
> Inconstent spacing fools people's eyes and leads to bugs,
> more often than not.
> 
> After 15 years of kernel development, I can remember at
> least 10 or so multi-week-debugging sessions that could
> have been curtailed had I not mis-read a poorly spaced
> C statement.
> 
> It matters in practical terms, not just consistency terms,
> trust me.

Sure, I buy that.  What I'm arguing here is why we have to be
consistently long instead of consistently short.  CodingStyle seems to
be silent on the question.  And a quick grep shows that while being in
the minority, I seem to be in a sizeable minority:
joern@Dublin:/usr/src/kernel/logfs$ sgrep ' \*)' .|wc
  51687  346050 4213259
joern@Dublin:/usr/src/kernel/logfs$ sgrep '[^ ]\*)' .|wc
  5838   33165  472462

What is the reason why (void *)foo is better than (void*)foo?  Just that
fact that by random chance one them them became more common in our
codebase and the minority always has to give in?

Jörn

-- 
A victorious army first wins and then seeks battle.
-- Sun Tzu
