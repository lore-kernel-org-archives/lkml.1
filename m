Return-Path: <linux-kernel-owner+w=401wt.eu-S1763956AbYBZUFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763956AbYBZUFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYBZUFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:05:01 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:50411 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbYBZUFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:05:00 -0500
Date: Tue, 26 Feb 2008 21:05:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kiran@scalemp.com, shai@scalemp.com, Glauber Costa <gcosta@redhat.com>
Subject: Re: [PATCH] x86: vSMP selection in config
Message-ID: <20080226200512.GA32685@uranus.ravnborg.org>
References: <200802210258.45011.yinghai.lu@sun.com> <200802241832.37850.yinghai.lu@sun.com> <200802242136.28744.yinghai.lu@sun.com> <200802242243.49576.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802242243.49576.yinghai.lu@sun.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 10:43:49PM -0800, Yinghai Lu wrote:
> 
> find out vSMP setting is going away in config after make oldconfig
> 
> vSMP need to PARAVIRT and PCI.
> so move PARAVIRT out of if PARAVIRT_GUEST, and make vSMP select PCI instead of
> depends on PCI
> 
> after patch vSMP could stick there.

I'm certain that we have hit a Kconfig bug / limitation here and
the patch below is just a workaround for that issue.

I tracked it down to a minimal case and hope Roman can provide
either an explanation or a fix.

IMO VSMP can wait until this is resolved properly and we should not
apply this patch.

	Sam
