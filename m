Return-Path: <linux-kernel-owner+w=401wt.eu-S932092AbZDJFlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbZDJFlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756846AbZDJFl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:41:27 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:42770 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbZDJFl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:41:26 -0400
Date: Fri, 10 Apr 2009 07:43:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [ANNOUNCE] headercheck - check dependencies on header files
Message-ID: <20090410054331.GB20005@uranus.ravnborg.org>
References: <20090409204219.GA31511@uranus.ravnborg.org> <1239334100.3036.14.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239334100.3036.14.camel@ht.satnam>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 08:58:20AM +0530, Jaswinder Singh Rajput wrote:
> Hello Sam,
> 
> On Thu, 2009-04-09 at 22:42 +0200, Sam Ravnborg wrote:
> > We have at several occasions discussed if our header files
> > should include their dependencies or not.
> > 
> > But we were lacking a tool to tell us if our header files
> > included the headerfiles they needed or not.
> > 
> > headercheck can be used to do so.
> > 
> > headercheck use the existing Kbuild files in
> > include/ to determine which directories to visit.
> > 
> > And for each directory it create one .c file for each
> > .h file and build it.
> > 
> > A .c file looks like this:
> > 
> > 	$cat module.h.c
> > 		#include <linux/module.h>
> > 
> 
> Is it possible to check that which header files are included in source
> file.
> 
> I mean how many header files are included for kernel/module.c and in
> which order and we can also check that same file is requested how many
> times, like:
> 
> 	linux/module.h (requested count, included or not)
> 	+linux/list.h
> 	++linux/stddef.h

Try to take a look at:
http://www.kernel.org/pub/linux/kernel/people/rayl/headergraphs/

and

http://www.kernel.org/pub/linux/kernel/people/acme/hviz

	Sam
