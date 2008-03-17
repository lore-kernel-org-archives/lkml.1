Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYCQNLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYCQNLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 09:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYCQNLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 09:11:40 -0400
Received: from styx.suse.cz ([82.119.242.94]:49668 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751544AbYCQNLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 09:11:40 -0400
Date: Mon, 17 Mar 2008 14:11:38 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Do not allow setting of quota limits to too high values
Message-ID: <20080317131138.GA17307@duck.suse.cz>
References: <20080312172255.GB21395@duck.suse.cz> <20080313130355.6a84d0c5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313130355.6a84d0c5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13-03-08 13:03:55, Andrew Morton wrote:
> 
> > Subject: [PATCH] Do not allow setting of quota limits to too high values
> 
> Please put "quota:" at the start of the title to identify the subsystem.  So,
> 
> Subject: [PATCH] quota: do not allow setting of quota limits to too high values
> 
> would have suited.  Thanks.
  Sorry for that. I've realized I forgot to add "quota:" only after I've sent
the email and figured out it's not worth resending it with "quota:" added.

> On Wed, 12 Mar 2008 18:22:55 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > From: Andrew Perepechko <andrew.perepechko@sun.com>
> > 
> > We should check whether quota limits set via Q_SETQUOTA are not exceeding
> > limits which quota format is able to handle.
> > 
> > Signed-off-by: Andrew Perepechko <andrew.perepechko@sun.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > 
> > ---
> >   Andrew, would you please queue it up for inclusion? Thanks.
> 
> For 2.6.26, I assume?  I am not able to determine the seriousness of this
> problem from the changelog nor from the patch itself.
  Not really serious. Nobody complained so far (i.e., for the time quota
exists) and the limits will just wrap when you try to set them over 4TB
now. So the patch can wait...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
