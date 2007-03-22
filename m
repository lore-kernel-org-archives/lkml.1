Return-Path: <linux-kernel-owner+w=401wt.eu-S965755AbXCVFnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965755AbXCVFnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 01:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965770AbXCVFnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 01:43:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57116 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965755AbXCVFnj (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 01:43:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
From: Keith Owens <kaos@ocs.com.au>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, sam@ravnborg.org
Subject: Re: $CHECK can't be overridden 
In-reply-to: Your message of "Thu, 22 Mar 2007 01:37:14 EDT."
             <20070322053714.GE17159@redhat.com> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 22 Mar 2007 16:43:42 +1100
Message-ID: <12875.1174542222@kao2.melbourne.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones (on Thu, 22 Mar 2007 01:37:14 -0400) wrote:
>On Thu, Mar 22, 2007 at 04:26:39PM +1100, Keith Owens wrote:
> > Dave Jones (on Thu, 22 Mar 2007 01:15:25 -0400) wrote:
> > >make help implies that supplying $CHECK on the command line
> > >should override sparse as the checker used when building with C=1
> > >Yet, this doesn't seem to be the case.
> > >
> > >This would be useful for cases where for eg, sparse isn't in
> > >the $PATH, allowing an explicit path to the executable to be
> > >passed in automated build environments.
> > 
> > Works for me.
> > 
> > # make C=1 CHECK=foo
>
>Ah, my bad. I was thinking it was an environment var rather
>than a makefile var.  I was using 'CHECK=foo make bzImage C=1'

The default for 'make' is that environment variables do _not_ override
variables defined in the Makefiles.  You can change that behaviour with
the -e flag, 'CHECK=foo make -e bzImage C=1' should work.  'info make'
recommends against using -e, changing environments can lead to
unexpected side effects.

