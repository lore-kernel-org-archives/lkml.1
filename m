Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbXKGEfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbXKGEfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 23:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756928AbXKGEet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 23:34:49 -0500
Received: from web36614.mail.mud.yahoo.com ([209.191.85.31]:24939 "HELO
	web36614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756890AbXKGEeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 23:34:46 -0500
X-YMail-OSG: wD1Bs2oVM1l_ET15AezctdeBOg8Ss2XdEdivZ_06OdqQy9T6ZYX7FX9ipMFoyq7htVE87ay_Vm3h6AH1Uk2OYuBKwKFtgZTbvTkInfcTfhYzp0Ii45o-
X-RocketYMMF: rancidfat
Date: Tue, 6 Nov 2007 20:34:45 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Defense in depth: LSM *modules*, not a static interface
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, casey@schaufler-ca.com
Cc: crispin@crispincowan.com, simon@fire.lp0.eu, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, cliffe@ii.net, oiaohm@gmail.com
In-Reply-To: <200711070411.lA74Bdvn041341@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <538323.91702.qm@web36614.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> Hello.
> 
> Casey Schaufler wrote:
> > Fine grained capabilities are a bonus, and there are lots of
> > people who think that it would be really nifty if there were a
> > separate capability for each "if" in the kernel. I personally
> > don't see need for more than about 20. That is a matter of taste.
> > DG/UX ended up with 330 and I say that's too many.
> 
> TOMOYO Linux has own (non-POSIX) capability that can support 65536
> capabilities
> if there *were* a separate capability for each "if" in the kernel.
>
http://svn.sourceforge.jp/cgi-bin/viewcvs.cgi/trunk/2.1.x/tomoyo-lsm/patches/tomoyo-capability.diff?root=tomoyo&view=markup
> 
> The reason I don't use POSIX capability is that the maximum types are limited
> to
> bitwidth of a variable (i.e. currently 32, or are we going to extend it to
> 64).
> This leads to abuse of CAP_SYS_ADMIN capability.

That is a matter of taste. 

> In other words, it makes fine-grained privilege division impossible.

I personally believe that a finer granularity than about 20
is too fine. I understand that this is a minority opinion.


Casey Schaufler
casey@schaufler-ca.com
