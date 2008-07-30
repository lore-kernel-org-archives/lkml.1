Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYG3WM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYG3WM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbYG3WMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:12:20 -0400
Received: from ns.suse.de ([195.135.220.2]:58377 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbYG3WMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:12:19 -0400
Date: Wed, 30 Jul 2008 15:04:32 -0700
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org,
       lf_kernel_messages@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Holzheu <holzheu@de.ibm.com>, Gerrit Huizenga <gh@us.ibm.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Jan Kara <jack@suse.cz>,
       Pavel Machek <pavel@ucw.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Joe Perches <joe@perches.com>,
       Jochen =?iso-8859-1?B?Vm/f?= <jochen.voss@googlemail.com>,
       Kunai Takashi <kunai@linux-foundation.jp>,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [patch 1/3] kmsg: Kernel message catalog macros.
Message-ID: <20080730220432.GA24800@suse.de>
References: <20080730165656.118280544@de.ibm.com> <20080730171156.824640459@de.ibm.com> <3ae72650807301502h3e54e80yb405af7192048b89@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ae72650807301502h3e54e80yb405af7192048b89@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 12:02:04AM +0200, Kay Sievers wrote:
> On Wed, Jul 30, 2008 at 18:56, Martin Schwidefsky
> <schwidefsky@de.ibm.com> wrote:
> 
> > +#define kmsg_dev_alert(id, dev, format, arg...) \
> > +       printk(__KMSG_CHECK(ALERT, id) KMSG_COMPONENT \
> > +               ": %s: " format, (dev)->bus_id , ## arg)
> 
> Care to use dev_name(), bus_id will be removed soon.

Hm, just use dev_printk() instead, it handles all of these kinds of
changes automatically.

thanks,

greg k-h
