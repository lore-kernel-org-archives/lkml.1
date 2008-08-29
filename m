Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbYH2WoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbYH2WoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 18:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYH2WoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 18:44:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54319 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbYH2WoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 18:44:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Date: Sat, 30 Aug 2008 00:47:56 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org> <200808292157.24179.rjw@sisk.pl> <48B87960.706@garzik.org>
In-Reply-To: <48B87960.706@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808300047.57310.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 30 of August 2008, Jeff Garzik wrote:
> Rafael J. Wysocki wrote:
> > Bisection turned up commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd as the culprit:
> > 
> > commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
> > Author: Yinghai Lu <yhlu.kernel@gmail.com>
> > Date:   Mon Aug 25 00:56:08 2008 -0700
> > 
> >     x86: fix HPET regression in 2.6.26 versus 2.6.25, check hpet against BAR, v3
> > 
> > Reverting this commit helps.
> > 
> > The symptom is that AHCI probe fails with this commit applied.
> 
> 
> Just to be sure...  Does "helps" imply that unresolved AHCI behavior 
> exists after reverting that commit?

No, after reverting this commit AHCI works normally.

Thanks,
Rafael
