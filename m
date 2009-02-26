Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbZBZRED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbZBZRED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 12:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbZBZRDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 12:03:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55736 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229AbZBZRDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 12:03:45 -0500
Date: Thu, 26 Feb 2009 18:03:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Ben Backx <ben@bbackx.com>, Henrik Kurelid <henrik@kurelid.se>
Subject: Re: [git pull] DVB + ieee1394: firedtv driver
Message-ID: <20090226170320.GA25475@elte.hu>
References: <tkrat.847a062a8a488f0d@s5r6.in-berlin.de> <20090226013708.GA16892@elte.hu> <49A6BC72.5050206@s5r6.in-berlin.de> <alpine.LFD.2.00.0902260824470.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902260824470.3111@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Two choices that I can see:
> 
>  - do the ieee1394_init() as a fs_initcall(), earlier
> 
>  - move drivers/ieee1394 linking up to before drivers/media
> 
> but I suspect that drivers/media wants to be early, in order to do the 
> _media_ layer initialization early.
> 
> Does this work?

yes, i just tested it and your patch fixes the crash:

 mercury:~> uname -a
 Linux mercury 2.6.29-rc6-tip-02011-gb62a1ed-dirty #250 SMP Thu 
 Feb 26 19:00:54 CET 2009 i686 athlon i386 GNU/Linux
 mercury:~> uptime
  19:02:51 up 0 min,  1 user,  load average: 3.97, 1.10, 0.37

Tested-by: Ingo Molnar <mingo@elte.hu>

Thanks!

	Ingo
