Return-Path: <linux-kernel-owner+w=401wt.eu-S939259AbXFHPrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939259AbXFHPrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764218AbXFHPrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:47:10 -0400
Received: from www.osadl.org ([213.239.205.134]:42972 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762558AbXFHPrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:47:09 -0400
Subject: Re: 2.6.21-rt2..8 troubles
From: Thomas Gleixner <tglx@linutronix.de>
To: Rui Nuno Capela <rncbc@rncbc.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <46660369.2070104@rncbc.org>
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org>
	 <460FE7F3.4060303@rncbc.org> <20070401183928.GB27614@elte.hu>
	 <46574DE4.2080900@rncbc.org> <1180195709.4264.7.camel@chaos>
	 <4658A4F4.1080204@rncbc.org>  <46660369.2070104@rncbc.org>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 17:47:05 +0200
Message-Id: <1181317625.4404.332.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 01:44 +0100, Rui Nuno Capela wrote:
> Just for the heads-up, I'm still suffering from this same illness, and
> it seems even worse (big freeze happens earlier) on 2.6.21.3-rt9.
> 
> There's no way around. On one box it works flawlessly (desktop,
> P4@3.3Ghz) while on the patient one (laptop, core2 T7200) it bricks
> silently.

Sorry for responding late. To have some idea where the breakage comes
from, can you please try

http://www.tglx.de/projects/hrtimers/2.6.22-rc4/patch-2.6.22-rc4-hrt5.patch

whether it has the same behaviour.

Thanks,

	tglx


