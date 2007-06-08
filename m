Return-Path: <linux-kernel-owner+w=401wt.eu-S1031823AbXFHSu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031823AbXFHSu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937664AbXFHSuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:50:39 -0400
Received: from www.osadl.org ([213.239.205.134]:52828 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937576AbXFHSui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:50:38 -0400
Subject: Re: 2.6.21-rt2..8 troubles
From: Thomas Gleixner <tglx@linutronix.de>
To: Rui Nuno Capela <rncbc@rncbc.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <59605.213.13.107.141.1181326897.squirrel@www.rncbc.org>
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org>
	 <460FE7F3.4060303@rncbc.org> <20070401183928.GB27614@elte.hu>
	 <46574DE4.2080900@rncbc.org> <1180195709.4264.7.camel@chaos>
	 <4658A4F4.1080204@rncbc.org>  <46660369.2070104@rncbc.org>
	 <1181317625.4404.332.camel@chaos>
	 <59605.213.13.107.141.1181326897.squirrel@www.rncbc.org>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 20:50:36 +0200
Message-Id: <1181328636.4404.335.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 19:21 +0100, Rui Nuno Capela wrote:
> >> There's no way around. On one box it works flawlessly (desktop,
> >> P4@3.3Ghz) while on the patient one (laptop, core2 T7200) it bricks
> >> silently.
> >
> > Sorry for responding late. To have some idea where the breakage comes
> > from, can you please try
> >
> > http://www.tglx.de/projects/hrtimers/2.6.22-rc4/patch-2.6.22-rc4-hrt5.pat
> > ch
> >
> > whether it has the same behaviour.
> >
> 
> Just built from linux-2.6.22-rc4.tar.bz2, with patch-2.6.22-rc4-hrt5.
> All's working apparentely nice on this offending machine (laptop, intel
> core2 T7200). In fact, I'm writing this very reply under it and through
> ipw3945 wifi module--which never was so pragmatic on -rt2..9 ;)
> 
> Nevertheless, this is not preempt-realtime (-rt) is it? And I it never
> complained about vanilla.
> 
> Is this good news though?

Well, the patch carries the same high resolution timer fixes as -rt, so
I just wanted to exclude those. Thanks for testing.

I'm spinning -rt10 with a couple of fixes. Should be out sometimes
tomorrow. If the problem persists, we need to dig deeper.

Thanks,

	tglx


