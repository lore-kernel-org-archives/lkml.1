Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYGaIg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYGaIg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 04:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYGaIgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 04:36:11 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:42032 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbYGaIgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 04:36:10 -0400
Subject: Re: [patch 1/3] kmsg: Kernel message catalog macros.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       lf_kernel_messages@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Holzheu <holzheu@de.ibm.com>, Gerrit Huizenga <gh@us.ibm.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Jan Kara <jack@suse.cz>,
       Pavel Machek <pavel@ucw.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Joe Perches <joe@perches.com>,
       Jochen =?ISO-8859-1?Q?Vo=DF?= <jochen.voss@googlemail.com>,
       Kunai Takashi <kunai@linux-foundation.jp>,
       Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <20080730193942.GA22441@suse.de>
References: <20080730165656.118280544@de.ibm.com>
	 <20080730171156.824640459@de.ibm.com>  <20080730193942.GA22441@suse.de>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 31 Jul 2008 10:35:52 +0200
Message-Id: <1217493352.8555.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-30 at 12:39 -0700, Greg KH wrote:
> > Index: linux-2.6/include/linux/kmsg.h
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6/include/linux/kmsg.h
> > @@ -0,0 +1,124 @@
> > +#ifndef _LINUX_KMSG_H
> > +#define _LINUX_KMSG_H
> > +
> > +#ifndef __KMSG_CHECKER
> > +#define __KMSG_CHECK(level, id) KERN_##level
> > +#endif
> 
> What if __KMSG_CHECKER is enabled?  What does __KMSG_CHECK resolve to
> then?
> 
> And what sets __KMSG_CHECKER?

The kmsg-doc script sets __KMSG_CHECKER and nothing else should ever
define it. It is used to preprocess the .c files to get at the kernel
messages. See process_cpp_file in the kmsg-doc script.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


