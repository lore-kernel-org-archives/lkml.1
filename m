Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYHQR3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYHQR3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYHQR3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:29:19 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:50043 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbYHQR3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:29:18 -0400
Subject: Re: [patch 1/3] kmsg: Kernel message catalog macros.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Tim Hockin <thockin@hockin.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org,
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
In-Reply-To: <b3ece790808161340x4b03b91er6f0bfcc46c6fb3ad@mail.gmail.com>
References: <20080730165656.118280544@de.ibm.com>
	 <200808131433.02966.rusty@rustcorp.com.au>
	 <1218733623.2651.14.camel@localhost>
	 <200808150922.23277.rusty@rustcorp.com.au>
	 <1218908985.6037.12.camel@localhost>
	 <b3ece790808161340x4b03b91er6f0bfcc46c6fb3ad@mail.gmail.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sun, 17 Aug 2008 19:28:58 +0200
Message-Id: <1218994138.20098.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-16 at 13:40 -0700, Tim Hockin wrote:
> >> > > Can you hash the format string to generate the id?  6 hex digits should
> >> > > be enough, and your tool can check for clashes.  As it's bad form to have
> >> > > identical strings for different semantics anyway, this seems to make
> >> > > sense.
> 
> > Ok, so  a specialized version of printk will do the work to calculate
> > the hash. Only, what will we do if there ever is a conflict? The message
> > tag has to be unique. The shorter the hash is, the more likely a
> > collision gets. Don't know if 6 hash digits is enough to just ignore the
> > problem.
> 
> And if you ever need to change the text that is in the format string?
> The hash changes.  That seems exactly counter to your goal...

The only problem here is trivial change like typos. Then the hash
changes although the message is semantically still the same. If the
message really changes, its id should change as well. 

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


