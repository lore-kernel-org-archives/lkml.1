Return-Path: <linux-kernel-owner+w=401wt.eu-S965002AbXG2V7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965002AbXG2V7B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935349AbXG2V6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:58:53 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2992 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935717AbXG2V6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:58:51 -0400
Date: Sun, 29 Jul 2007 17:58:16 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eugene Teo <eteo@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jeremy@goop.org,
       martin.pitt@ubuntu.com, wwoods@redhat.com
Subject: Re: [PATCH 2/3] core_pattern: allow passing of arguments to user mode helper when core_pattern is a pipe
Message-ID: <20070729215816.GA10896@hmsreliant.homelinux.net>
References: <20070727200746.GC18946@hmsreliant.homelinux.net> <46AC9021.7060807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AC9021.7060807@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 09:03:29PM +0800, Eugene Teo wrote:
> Neil Horman wrote:
> [...]
> > +			/* core limit size */
> > +			case 'c':
> > +				rc = snprintf(out_ptr, out_end - out_ptr,
> > +					      "%lu", current->signal->rlim[RLIMIT_CORE].rlim_cur); 
> 
> Trailing space.
> 
> [...]
> > - 		if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
> > + 		if(call_usermodehelper_pipe(corename+1, helper_argv, NULL, &file)) {
>    ^^^^^^^^^^^^^
> 
> Use tabs, and a missing space after '('.
> 
I think your reader is screwing up the patch.  The version that I sent, which I
have here, shows that as all tabs, no spaces.

As for the '(', yeah, that looks like its been there for awhile.  I'll clean it
all up when I address macro expansion, as per the conversation Martin and I have
been holding.

Regards
Neil
 
> Eugene

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
