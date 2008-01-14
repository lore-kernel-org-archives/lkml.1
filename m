Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYANRKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYANRKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 12:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbYANRKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 12:10:07 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4546 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbYANRKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:10:06 -0500
Date: Mon, 14 Jan 2008 17:10:23 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: rdunlap@xenotime.net, jschopp@austin.ibm.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Checkpatch.pl failure
Message-ID: <20080114171023.GB19327@shadowen.org>
References: <1200325734.3159.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200325734.3159.1.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 09:48:53AM -0600, James Bottomley wrote:
> This error:
> 
> ERROR: no space before that close parenthesis ')'
> #501: FILE: drivers/scsi/dpt_i2o.c:2299:
> +               if (dev_status == 0x02 /*CHECK_CONDITION*/) {
> 
> Is definitely wrong.  I think it's stripped the comments so now the if
> looks to have a space before the bracket, but stylistically the
> complaint it has errored out for is wrong.

Yes, that is kinda wrong.  Its a difficult one to deal with nicely as
basically spacing goes to hell when comments are wedged in the middle.
The rules basically go out the window.  In the next version I do at
least have a handle on where comments are, but we have not yet
progressed to where we can simply get the spacing checks right.

I'll think more on it, and see what we can do.

-apw
