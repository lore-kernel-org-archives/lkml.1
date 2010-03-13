Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab0CMT7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 14:59:09 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13096 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab0CMT7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 14:59:07 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5919"; a="36309188"
Subject: Re: [GIT PULL] fix for msm_sdcc MMC driver for 2.6.34-rc1
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100313075248.GK12554@elf.ucw.cz>
References: <1268081936.14857.60.camel@c-dwalke-linux.qualcomm.com>
	 <20100313075248.GK12554@elf.ucw.cz>
Content-Type: text/plain
Date: Sat, 13 Mar 2010 11:57:48 -0800
Message-Id: <1268510268.21952.294.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-13 at 08:52 +0100, Pavel Machek wrote:
> On Mon 2010-03-08 12:58:56, Daniel Walker wrote:
> > Just one small trivial fix.
> > 
> > The following changes since commit 6b7b284958d47b77d06745b36bc7f36dab769d9b:
> >   Linus Torvalds (1):
> >         Linux 2.6.33-rc2
> > 
> > are available in the git repository at:
> > 
> >   git://codeaurora.org/quic/kernel/dwalker/linux-msm.git msm-mmc_sdcc
> > 
> > Roel Kluin (1):
> >       msm_sdcc.c: missing brackets in msmsdcc_resume()
> 
> Cool, 2.6.34-rc1 boots on HTC Dream, as did 2.6.33. Does this mean I
> should try to set up MMC, too? MMC worked in your -working-mmc tree in
> 2.6.33...

No it shouldn't work in mainline yet. I am planning to integrate it into
-next tho.. I need to bring in SMD, which we also have in staging. There
are two divergent SMD development lines which I need to find some
solution to. The staging version is one development line from Google,
the other one is from Qualcomm .. MMC has a similar problem.

Daniel

