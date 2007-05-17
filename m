Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbXEQM2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbXEQM2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbXEQM2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:28:17 -0400
Received: from lazybastard.de ([212.112.238.170]:43154 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbXEQM2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:28:15 -0400
Date: Thu, 17 May 2007 14:05:21 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Dongjun Shin <djshin90@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070517120520.GA15676@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <20070515133759.9ee434a2.akpm@linux-foundation.org> <1179317240.2859.222.camel@shinybook.infradead.org> <20070516083408.dcd9dd78.akpm@linux-foundation.org> <1179330596.2859.248.camel@shinybook.infradead.org> <20070516164158.GB8113@lazybastard.org> <7fe698080705162312t4e7ed90byd10ef8e664027b17@mail.gmail.com> <1179383117.2859.416.camel@shinybook.infradead.org> <7fe698080705170120w18fe5521oa685cf248a45e1c6@mail.gmail.com> <1179391440.2859.447.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1179391440.2859.447.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 16:43:59 +0800, David Woodhouse wrote:
> 
> > As I mentioned, some techniques like log-structured filesystem could
> > perform generally better on any kind of flash-based storage with FTL.
> > Although there are many kinds of FTL, it is commonly true that
> > it performs well under workload where sequential write is dominant.
> 
> Yes, it's certainly possible that we _could_ write a file system which
> is specifically targeted at FTL -- I was just wondering why anyone would
> _bother_ :)

Haven't you done that already?  JFFS2 write behaviour is the best-case
scenario for any FTL.  When the delta cache is finished, LogFS will be
pretty close to that as well.

Not sure if anyone would specifically target FTL.  Being well-suited for
those beasts is just a side-effect.

The FTL is still a net loss.  Without that FAT enabling layer a real
flash filesystem would be more efficient.

Jörn

-- 
Prosperity makes friends, adversity tries them.
-- Publilius Syrus
