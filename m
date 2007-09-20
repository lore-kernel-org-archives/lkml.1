Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbXITTuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbXITTuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbXITTuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:50:25 -0400
Received: from www.osadl.org ([213.239.205.134]:46485 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750864AbXITTuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:50:24 -0400
Subject: Re: Lossy interrupts on x86_64
From: Thomas Gleixner <tglx@linutronix.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200709201222.55278.jbarnes@virtuousgeek.org>
References: <200709120833.15980.jbarnes@virtuousgeek.org>
	 <200709171213.21511.jbarnes@virtuousgeek.org>
	 <1190056703.2995.11.camel@chaos>
	 <200709201222.55278.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 21:50:18 +0200
Message-Id: <1190317818.3053.1.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 12:22 -0700, Jesse Barnes wrote:
> > Eeek, that sounds scary. Can you add "highres=off" as well ?
> 
> FWIW I just tried your linux-2.6-hires tree with the attached config and 
> still see the problem.  It doesn't look like NO_HZ is even an option in 
> that tree...

Right, that's a 2.6-hrt update tree for Linus to pull. The 64 bit parts
are not in there. It's basically Linus + some fixes. 

	tglx


