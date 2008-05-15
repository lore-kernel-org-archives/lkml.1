Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbYEOGMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbYEOGMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 02:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYEOGMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 02:12:01 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54323 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbYEOGMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 02:12:00 -0400
Message-Id: <200805150611.m4F6Bv4J046219@www262.sakura.ne.jp>
Subject: Re: Kernel hangs in SMP + VMware environment.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Alok Kataria <akataria@vmware.com>
Cc: devzero@web.de, linux-kernel@vger.kernel.org,
       Dan Hecht <dhecht@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Thu, 15 May 2008 15:11:57 +0900
References: <1210789834.8798.20.camel@promb-2n-dhcp368.eng.vmware.com>
In-Reply-To: <1210789834.8798.20.camel@promb-2n-dhcp368.eng.vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alok Kataria wrote:
> Can you try the patch attached with this mail, I made this on top of
> 2.6.24.7 but should fit on any other 2.6.24 based distro kernel.

I tried 2.6.24.5-85.fc8 with your patch, and I can no longer reproduce
this problem. I think the problem has been solved.

Also, workaround till your patch is applied to distro kernels seems to be
to add "clocksource=jiffies" or something to avoid using tsc as clocksource.
Fedora 9's 2.6.25-14.fc9 also hangs since the default clocksource is tsc, but
with "clocksource=jiffies" added, I encounter no hangs so far.

>From today, I can compile kernels using 2 CPUs.
Thank you very much.
