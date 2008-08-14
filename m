Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbYHNXXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbYHNXXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 19:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYHNXXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 19:23:04 -0400
Received: from ozlabs.org ([203.10.76.45]:51142 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYHNXXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 19:23:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: schwidefsky@de.ibm.com
Subject: Re: [patch 1/3] kmsg: Kernel message catalog macros.
Date: Fri, 15 Aug 2008 09:22:22 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       lf_kernel_messages@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Holzheu <holzheu@de.ibm.com>, Gerrit Huizenga <gh@us.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Jan Kara <jack@suse.cz>,
       Pavel Machek <pavel@ucw.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Joe Perches <joe@perches.com>,
       Jochen =?utf-8?q?Vo=C3=9F?= <jochen.voss@googlemail.com>,
       Kunai Takashi <kunai@linux-foundation.jp>,
       Tim Bird <tim.bird@am.sony.com>
References: <20080730165656.118280544@de.ibm.com> <200808131433.02966.rusty@rustcorp.com.au> <1218733623.2651.14.camel@localhost>
In-Reply-To: <1218733623.2651.14.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808150922.23277.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 August 2008 03:07:03 Martin Schwidefsky wrote:
> On Wed, 2008-08-13 at 14:33 +1000, Rusty Russell wrote:
> > On Thursday 31 July 2008 02:56:57 Martin Schwidefsky wrote:
> > > From: Michael Holzheu <holzheu@de.ibm.com>
> > > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > >
> > > Introduce a new family of printk macros which prefixes each kmsg
> > > message with a component name and allows to tag the printk with a
> > > message id.
> >
> > Can you hash the format string to generate the id?  6 hex digits should
> > be enough, and your tool can check for clashes.  As it's bad form to have
> > identical strings for different semantics anyway, this seems to make
> > sense.
>
> First, how do you do that with the C preprocessor? Second the kmsg-doc
> script will check that the message format strings match if a kmsg with a
> specific id is used in multiple locations.

Well, why would you do it with the preprocessor?  It's simplest to spit it out 
at runtime.

The (offline) catalogger will need to generate them, of course.
Rusty.


