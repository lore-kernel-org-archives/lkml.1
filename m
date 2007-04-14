Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbXDNRfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbXDNRfm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 13:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbXDNRfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 13:35:42 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37923 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbXDNRfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 13:35:41 -0400
X-Originating-Ip: 24.6.145.253
Date: Sat, 14 Apr 2007 13:33:13 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Ralf Baechle <ralf@linux-mips.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dhowells@redhat.com, sfr@canb.auug.org.au
Subject: {Spam?} Re: {Spam?} [PATCH] Remove all traces of legacy power management.
In-Reply-To: <20070414180451.GA4525@linux-mips.org>
Message-ID: <Pine.LNX.4.64.0704141332400.13774@localhost.localdomain>
References: <Pine.LNX.4.64.0704141125410.15722@localhost.localdomain>
 <20070414180451.GA4525@linux-mips.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: spam, SORBS-DUL,
	SpamAssassin (not cached, score=-12.808, required 5,
	ALL_TRUSTED -1.80, BAYES_00 -15.00, RCVD_IN_NJABL_DUL 1.95,
	RCVD_IN_SORBS_DUL 2.05)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Apr 2007, Ralf Baechle wrote:

> On Sat, Apr 14, 2007 at 12:49:54PM -0400, Robert P. J. Day wrote:
> > Date:	Sat, 14 Apr 2007 12:49:54 -0400 (EDT)
> > From:	"Robert P. J. Day" <rpjday@mindspring.com>
> > To:	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> > cc:	dhowells@redhat.com, Ralf Baechle <ralf@linux-mips.org>,
> > 	sfr@canb.auug.org.au
> > Subject: {Spam?} [PATCH] Remove all traces of legacy power management.
> > Content-Type: TEXT/PLAIN; charset=US-ASCII
> >
> >
> > Remove everything related to legacy power management.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
>
> > diff --git a/arch/mips/au1000/common/power.c b/arch/mips/au1000/common/power.c
> > index 3901e8e..f3685d6 100644
> > --- a/arch/mips/au1000/common/power.c
> > +++ b/arch/mips/au1000/common/power.c
> > @@ -278,13 +278,11 @@ static int pm_do_sleep(ctl_table * ctl, int write, struct file *file,
> >  		p = buf;
> >  		sleep_ticks = simple_strtoul(p, &p, 0);
> >  #endif
> > -		retval = pm_send_all(PM_SUSPEND, (void *) 2);
> >
> >  		if (retval)
> >  			return retval;
> >
> >  		au_sleep();
> > -		retval = pm_send_all(PM_RESUME, (void *) 0);
> >  	}
> >  	return retval;
> >  }
> > @@ -297,12 +295,10 @@ static int pm_do_suspend(ctl_table * ctl, int write, struct file *file,
> >  	if (!write) {
> >  		*len = 0;
> >  	} else {
> > -		retval = pm_send_all(PM_SUSPEND, (void *) 2);
> >  		if (retval)
> >  			return retval;
> >  		suspend_mode = 1;
> >
> > -		retval = pm_send_all(PM_RESUME, (void *) 0);
> >  	}
> >  	return retval;
> >  }
>
> Both segments leave the variable retval as zero initialized and only used
> for the return value ...  I'm not sure what these functions actually
> should do - but after your patches they have essentially become glorified
> nops.

ah, good point.  feel free to send me a MIPS-specific patch and i can
incorporate it, if you want.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
