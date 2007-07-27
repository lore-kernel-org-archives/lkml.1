Return-Path: <linux-kernel-owner+w=401wt.eu-S1765040AbXG0Kej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765040AbXG0Kej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 06:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760084AbXG0Ke3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 06:34:29 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2532 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764931AbXG0Ke2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 06:34:28 -0400
Date: Fri, 27 Jul 2007 06:32:55 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, wwoods@redhat.com
Subject: Re: [PATCH] core_pattern: Add ability for core_pattern to parse arguments when pattern is a pipe
Message-ID: <20070727103255.GA16269@hmsreliant.homelinux.net>
References: <20070726173923.GA5701@hmsreliant.homelinux.net> <46A919EB.9060102@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A919EB.9060102@goop.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 03:02:19PM -0700, Jeremy Fitzhardinge wrote:
> Neil Horman wrote:
> > +static void free_argv_array(char **argv)
> > +{
> > +	int i;
> > +	if (argv != NULL) {
> > +		for (i = 0; argv[i] != NULL; i++)
> > +			kfree(argv[i]);
> > +		kfree(argv);
> > +	}
> > +
> > +}
> >   
> 
> I've helpfully already provided free_argv() in lib/argv_split.c.
> 
> > +
> > +/*
> > + * format_corename_argv will inspect the corename string, 	
> > + * and for every option found after the binary name
> > + * it will remove the option from the string, and place it
> > + * in the argv array, that can then be passed to the 
> > + * usermodehelper if core_pattern is a pipe
> > + * Assumes that corename is declared on the stack of the caller
> > + */
> > +static char **format_corename_argv(char *corename)
> > +{
> >   
> 
> And it looks like this could be adapted to use argv_split() with a bit
> of additional processing.
> 
>     J
I didn't see these, thanks.  I've got the aforementioned misc cleanup patch to
send for this work to Andrew still, I'll roll these changes in with it.

Regards
Neil


-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
