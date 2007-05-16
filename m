Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbXEPMHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbXEPMHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760040AbXEPMHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:07:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48155 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759498AbXEPMHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:07:37 -0400
Subject: Re: [PATCH] LogFS take three
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
In-Reply-To: <20070515133759.9ee434a2.akpm@linux-foundation.org>
References: <20070515151919.GA32510@lazybastard.org>
	 <20070515133759.9ee434a2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 16 May 2007 20:07:18 +0800
Message-Id: <1179317240.2859.222.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-15 at 13:37 -0700, Andrew Morton wrote:
> But it includes an MTD header file.
> 
> Can this code be tested by people who don't have MTD hardware?  We used to
> ahve a fake-mtd-on-a-blockdev thing, whcih was in a state of some
> disrepair.  Maybe it got repaired.  Or removed.  I can't immediately locate
> it...

There's block2mtd, as Jörn pointed out. There's also 'nandsim' and
'mtdram', which will vmalloc some space and use that to emulate NAND or
NOR flash, respectively.

> It's strange and a bit regrettable that an fs would have dependency on MTD,
> really.

Why? Other file systems has dependencies on BLOCK or on NET. It seems
entirely normal to me.

-- 
dwmw2

