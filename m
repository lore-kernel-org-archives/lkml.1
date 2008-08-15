Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbYHOUnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbYHOUnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbYHOUnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:43:13 -0400
Received: from planb.casita.net ([69.55.228.155]:4305 "EHLO planb.casita.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbYHOUnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:43:12 -0400
X-Greylist: delayed 1910 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Aug 2008 16:43:12 EDT
Date: Fri, 15 Aug 2008 16:05:30 -0400 (EDT)
From: Rick Troth <rmt@casita.net>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org,
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
Subject: Re: [patch 1/3] kmsg: Kernel message catalog macros.
In-Reply-To: <200808131433.02966.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.58.0808130921180.14304@jeremiah.casita.net>
References: <20080730165656.118280544@de.ibm.com> <20080730171156.824640459@de.ibm.com>
 <200808131433.02966.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008, Rusty Russell wrote:
>
> Can you hash the format string to generate the id?  6 hex digits should be
> enough, and your tool can check for clashes.  As it's bad form to have
> identical strings for different semantics anyway, this seems to make sense.

I second this suggestion (or propose something like it).
A short hash or even an index into some off-line table
lets the user hit the right page when looking for an explanation.

I've been using a similar (and perhaps ugly to some eyes)
numeric message catalog for years (with token substitution and all).
The catalogs can be translated and then replaced with local language
so the users don't have to learn English (or French, or German,
or Japanese, or Chinese).

-- R;   <><

