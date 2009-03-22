Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbZCVVVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbZCVVVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 17:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbZCVVVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 17:21:08 -0400
Received: from bu3sch.de ([62.75.166.246]:50163 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbZCVVVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 17:21:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Date: Sun, 22 Mar 2009 22:19:49 +0100
User-Agent: KMail/1.9.9
Cc: Rui Santos <rsantos@grupopie.com>,
       Michael =?utf-8?q?B=C3=BCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org
References: <200903041828.49972.m.bueker@berlin.de> <49BE4EF6.3030406@grupopie.com> <20090322211159.GA23042@electric-eye.fr.zoreil.com>
In-Reply-To: <20090322211159.GA23042@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903222219.50112.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 March 2009 22:12:00 Francois Romieu wrote:
> Rui Santos <rsantos@grupopie.com> :
> [...]
> > I Finally ended up the big bisect operation. The commit responsible for
> > this issue is commit
> > b726e493e8dc13537d1d7f8cd66bcd28516606c3
> > labeled
> > 'r8169: sync existing 8168 device hardware start sequences with vendor
> > driver'
> 
> Thanks a lot for the bisect.
> 
> > With that patch removed, I  was able to get a sustained 40MB/s+ on a
> > 20GB ftp transfer. I wasn't able to do it with the specified patch applied.
> > Just as a side note, I was never able to reproduce it on a 100MBit
> > connection, only on a full 1GBit one...

I can trigger it on a 100MBit connection, but it takes a _lot_ more time (something
like 4 hours or so of continuous traffic). On a 1GBit connection it takes only a few minutes.

> > However this patch will not reverse on the current kernel.
> > 
> > What do you think the next step should be ?
> > As usual, if you need any testing, please do let me know.
> 
> Can you see if one of the attached patches or a combination of them
> makes a difference for the current (-git) kernel ?

Thanks a lot. I will try these. Will take some time, because this is a
production server and I'll have to take care to not completely bring it down. :)

-- 
Greetings, Michael.
