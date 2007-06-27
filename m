Return-Path: <linux-kernel-owner+w=401wt.eu-S1760928AbXF0SWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928AbXF0SWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 14:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbXF0SWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 14:22:25 -0400
Received: from eastrmmtao102.cox.net ([68.230.240.8]:52515 "EHLO
	eastrmmtao102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbXF0SWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 14:22:25 -0400
X-Greylist: delayed 990 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2007 14:22:24 EDT
Date: Wed, 27 Jun 2007 14:05:52 -0400
From: Chris Shoemaker <c.shoemaker@cox.net>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, josh@kernel.org
Subject: Re: [PATCH] CodingStyle: Add information about trailing whitespace.
Message-ID: <20070627180552.GA746@pe.Belkin>
References: <1182967160.8970.108.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182967160.8970.108.camel@josh-work.beaverton.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 10:59:20AM -0700, Josh Triplett wrote:
> +Do not leave trailing whitespace at the ends of lines.  Some editors with
> +"smart" indentation will insert whitespace at the beginning of new lines as
> +appropriate, so you can start typing the next line of code right away.
> +However, some such editors do not remove the whitespace if you end up not
> +putting a line of code there, such as if you leave a blank line.  As a result,
> +you end up with lines containing trailing whitespace.
> +
> +Git will warn you about patches that introduce trailing whitespace, and can
> +optionally strip the trailing whitespace for you; however, if applying a series
> +of patches, this may make later patches in the series fail by changing their
> +context lines.

What I'd really like to see is, _why_ is trailing whitespace
considered harmful?  Something about MUAs not preserving it or
something?

-chris
