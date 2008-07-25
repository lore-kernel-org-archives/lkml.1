Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbYGYVur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbYGYVur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbYGYVu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:50:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756787AbYGYVu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:50:27 -0400
Date: Fri, 25 Jul 2008 14:50:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: david-b@pacbell.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [patch 2.6.26-git] pm selftest:  rtc paranoia
Message-Id: <20080725145023.8a18c988.akpm@linux-foundation.org>
In-Reply-To: <20080725144946.5e1b78c8.akpm@linux-foundation.org>
References: <200807251326.51987.david-b@pacbell.net>
	<20080725144946.5e1b78c8.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 14:49:46 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> >  	}
> >  	if (status < 0)
> >  		printk(err_suspend, status);
> > +
> > +	/* Some platforms can't detect that the alarm triggered the
> > +	 * wakeup, or (accordingly) disable it after it afterwards.
> > +	 * It's supposed to give oneshot behavior; cope.
> > +	 */
> > +	alm.enabled = false;
> > +	rtc_set_alarm(rtc, &alm);
> >  }
> >  
> >  static int __init has_wakealarm(struct device *dev, void *name_ptr)
> 
> I assume this fixes some reported bug?  Any references?
> 
> Is this needed in 2.6.26.x?  2.6.25.x?

oh.  pm-selftest is new.  Ignore me.
