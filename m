Return-Path: <linux-kernel-owner+w=401wt.eu-S934522AbXFFTAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934522AbXFFTAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761375AbXFFTA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:00:28 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49953 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758473AbXFFTA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:00:28 -0400
Date: Wed, 6 Jun 2007 15:00:27 -0400
From: Jeff Garzik <jeff@garzik.org>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Josh Triplett <josh@freedesktop.org>
Subject: Re: generic bool and sparse errors?
Message-ID: <20070606190027.GD23143@havoc.gtf.org>
References: <4666FD0A.4060609@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4666FD0A.4060609@intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 11:29:30AM -0700, Kok, Auke wrote:
> alternatively we might need to reconsider the `typedef _Bool bool;` 
> declaration and force it to be unsigned. I'm not sure what to think of that.

That's the C99 standard declaration IIRC.  Probably just need to __force
it to something for sparse, deep in the bowels of kernel headers...

	Jeff



