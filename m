Return-Path: <linux-kernel-owner+w=401wt.eu-S1760324AbXGIUXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324AbXGIUXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 16:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbXGIUXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 16:23:00 -0400
Received: from waste.org ([66.93.16.53]:51082 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbXGIUXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 16:23:00 -0400
Date: Mon, 9 Jul 2007 15:22:17 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: maps2-move-the-page-walker-code-to-lib.patch
Message-ID: <20070709202217.GS11115@waste.org>
References: <1183873796.6005.269.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183873796.6005.269.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 03:49:56PM +1000, Rusty Russell wrote:
> Matt wrote:
> > This lets it get shared outside of proc/ and linked in only when needed.
> 
> Erk, this really belongs in the mm dir.  You can use "lib-y +=
> pagewalk.o" there, and it seems to work as well as doing it in lib.

Are you sure? I tested that a few months ago and it didn't work for
me. I seem to recall it wanted a chunk of makefile surgery.

-- 
Mathematics is the supreme nostalgia of our time.
