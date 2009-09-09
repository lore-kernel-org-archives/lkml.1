Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbZIIOeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbZIIOeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZIIOeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:34:08 -0400
Received: from bar.sig21.net ([80.81.252.164]:53363 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbZIIOeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:34:07 -0400
Date: Wed, 9 Sep 2009 16:33:55 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
Message-ID: <20090909143354.GA15973@sig21.net>
References: <20090814170228.GM13320@pengutronix.de>
 <1158166a0908141304y70300ab3p899b0d4609efded9@mail.gmail.com>
 <20090814204305.GA31727@pengutronix.de>
 <20090815103532.GA5596@sig21.net>
 <20090904161626.GD3207@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904161626.GD3207@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.5 (---)
X-Spam-21-Report: No, score=-3.5 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.898,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for slow reply.

On Fri, Sep 04, 2009 at 06:16:26PM +0200, Wolfram Sang wrote:
> 
> > Now that microcom is in Debian sid (thanks!), where can I find ptx_ts?
> > It seems to be quite useful.
> 
> Back from the holidays, so here it is:
> 
> http://pengutronix.de/software/ptx_ts/index_en.html
> 
> Hope it can be useful...

Yes, it is.  Thanks!

BTW, some feedback about microcom:

- the choice of ^\ as an escape charater is unfortunate since that
  is usually mapped to set SIGQUIT in the tty; a btter choice would
  be ^] (like telnet) or ^A (like minicom)
- typing the escape character immediate causes the menu to be displayed,
  so one cannot send a break sequence for SysRq without cluttering up the screen

Would you take patches for that?


Johannes
