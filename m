Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbZBPHLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbZBPHLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 02:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZBPHLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 02:11:37 -0500
Received: from ozlabs.org ([203.10.76.45]:37906 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbZBPHLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 02:11:36 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tim Abbott <tabbott@mit.edu>
Subject: Re: [PATCH 6/7] Ksplice: Export symbols needed for Ksplice
Date: Mon, 16 Feb 2009 17:41:33 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Jeff Arnold <jbarnold@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>,
       Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Nikanth Karthikesan <knikanth@suse.de>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <200902042205.09651.rusty@rustcorp.com.au> <alpine.DEB.2.00.0902080129020.11936@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.2.00.0902080129020.11936@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902161741.34134.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 February 2009 12:16:40 Tim Abbott wrote:
> On Wed, 4 Feb 2009, Rusty Russell wrote:
> 
> > On Saturday 06 December 2008 10:33:59 Jeff Arnold wrote:
> > > From: Tim Abbott <tabbott@mit.edu>
> > > 
> > > Ksplice uses several functions from module.c in order to resolve
> > > symbols and implement dependency handling.  Calling these functions
> > > requires holding module_mutex, so it is exported.
> > 
> > I have fought every attempt to export that.  It was long a cause of misery
> > and pain; people saw the lock and so started grabbing it.
> > 
> > Any chance we can find another way?
> 
> It is definitely possible, but it wouldn't be pretty.  There are a few 
> things that we use module_mutex for:

Yes, having looked through the code I don't think the export can be avoided.

Thanks,
Rusty.
