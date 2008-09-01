Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYIAMm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYIAMm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 08:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYIAMmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 08:42:19 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:56727 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbYIAMmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 08:42:18 -0400
Subject: Re: [patch 1/3] kmsg: Kernel message catalog macros.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       lf_kernel_messages@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Holzheu <holzheu@de.ibm.com>, Gerrit Huizenga <gh@us.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Jan Kara <jack@suse.cz>,
       Pavel Machek <pavel@ucw.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Joe Perches <joe@perches.com>,
       Jochen =?ISO-8859-1?Q?Vo=DF?= <jochen.voss@googlemail.com>,
       Kunai Takashi <kunai@linux-foundation.jp>,
       Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <200808261138.28076.rusty@rustcorp.com.au>
References: <20080730165656.118280544@de.ibm.com>
	 <200808131433.02966.rusty@rustcorp.com.au>
	 <1219679790.16131.28.camel@localhost>
	 <200808261138.28076.rusty@rustcorp.com.au>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 01 Sep 2008 14:28:50 +0200
Message-Id: <1220272130.23719.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 11:38 +1000, Rusty Russell wrote:
> On Tuesday 26 August 2008 01:56:30 Martin Schwidefsky wrote:
> > On Wed, 2008-08-13 at 14:33 +1000, Rusty Russell wrote:
> > > Can you hash the format string to generate the id?  6 hex digits should
> > > be enough, and your tool can check for clashes.  As it's bad form to have
> > > identical strings for different semantics anyway, this seems to make
> > > sense.
> >
> > If we go with hashes there is one more thing: kmsg(0, <string>)
> > The variant where we manually assign the message ids knows about the
> > "special" id 0. There is no documentation required for id 0 and none is
> > wanted. If we replace the manual ids with hashes this will get lost. You
> > could argue that a kmsg with id 0 is a normal printk so why not just use
> > printk? What is lost is the information that this printk has been found
> > to be not important enough to be documented.
> 
> Hmm, #define KERN_IGNORE KERN_DEBUG?

Hmm, shouldn't KERN_xxx levels be independent of the special id 0? 

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


