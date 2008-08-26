Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYHZLzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYHZLzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 07:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbYHZLzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 07:55:14 -0400
Received: from ozlabs.org ([203.10.76.45]:45572 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbYHZLzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 07:55:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: schwidefsky@de.ibm.com
Subject: Re: [patch 1/3] kmsg: Kernel message catalog macros.
Date: Tue, 26 Aug 2008 11:38:26 +1000
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
References: <20080730165656.118280544@de.ibm.com> <200808131433.02966.rusty@rustcorp.com.au> <1219679790.16131.28.camel@localhost>
In-Reply-To: <1219679790.16131.28.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808261138.28076.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008 01:56:30 Martin Schwidefsky wrote:
> On Wed, 2008-08-13 at 14:33 +1000, Rusty Russell wrote:
> > Can you hash the format string to generate the id?  6 hex digits should
> > be enough, and your tool can check for clashes.  As it's bad form to have
> > identical strings for different semantics anyway, this seems to make
> > sense.
>
> If we go with hashes there is one more thing: kmsg(0, <string>)
> The variant where we manually assign the message ids knows about the
> "special" id 0. There is no documentation required for id 0 and none is
> wanted. If we replace the manual ids with hashes this will get lost. You
> could argue that a kmsg with id 0 is a normal printk so why not just use
> printk? What is lost is the information that this printk has been found
> to be not important enough to be documented.

Hmm, #define KERN_IGNORE KERN_DEBUG?

Rusty.
