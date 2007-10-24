Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbXJXPQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbXJXPQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbXJXPQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:16:29 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:7661 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247AbXJXPQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:16:29 -0400
X-Belgacom-Dynamic: yes
Date: Wed, 24 Oct 2007 17:22:40 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gilles Gigan <gilles.gigan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: add Nano 7240 driver
Message-ID: <20071024152240.GB6015@infomag.infomag.iguana.be>
References: <20071024121159.03d209ec.gilles.gigan@gmail.com> <20071023192948.1fe5dd8d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023192948.1fe5dd8d.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

> > +	case WDIOC_SETOPTIONS:{
> > +			int retval = -EINVAL;
> > +
> > +			if (arg & WDIOS_DISABLECARD) {
> > +				wdt_disable();
> > +				retval = 0;
> > +			}
> > +
> > +			if (arg & WDIOS_ENABLECARD) {
> > +				wdt_enable();
> > +				retval = 0;
> > +			}
> > +
> > +			return retval;
> 
> hrm.  So if userspace does ioctl(..., WDIOS_DISABLECARD|WDIOS_ENABLECARD,
> that happens to be equivalent to WDIOS_ENABLECARD?
> 
> Do all watchdog drivers do it exactly the same way, or are we offering
> inconsistent interfaces between different drivers?

I fear that all watchdog drivers do it more or less like this.

I'll have a look at it later on.

Greetings,
Wim.

