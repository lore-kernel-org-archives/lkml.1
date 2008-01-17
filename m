Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbYAQPmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbYAQPmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 10:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYAQPl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 10:41:59 -0500
Received: from styx.suse.cz ([82.119.242.94]:54277 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752190AbYAQPl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 10:41:58 -0500
Date: Thu, 17 Jan 2008 16:41:54 +0100
From: Jan Kara <jack@suse.cz>
To: Sebastian Manciulea <manciuleas@yahoo.com>
Cc: linux-kernel@vger.kernel.org, psusi@cfl.rr.com, marcin.slusarz@gmail.com
Subject: Re: patch with support for UDF 2.50 (read-only)
Message-ID: <20080117154154.GA10549@duck.suse.cz>
References: <186027.56226.qm@web43144.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <186027.56226.qm@web43144.mail.sp1.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Wed 16-01-08 16:33:39, Sebastian Manciulea wrote:
> More the a year ago me and my colleague posted a patch
> on  the Linux UDF site
> (http://sourceforge.net/projects/linux-udf/) which
> adds support to Linux for reading UDF 2.50 formatted
> media. In time I've updated the patches for the newer
> kernel versions and did some bug-fixing. The patch has
> been tested over time with various types of media
> (BD-ROM, BD-RE, BD-R, DVD, CD) and it looks pretty
> stable.
> I wonder if someone can take a look at the patch and
> let me know if it's ready for inclusion into the
> mainline kernel, or at least direct me to the
> appropriate sub-system maintainer.
  Thanks for writing the support. I was already wondering whether someone
would submit the patch for inclusion ;).  There's no real UDF maintainer.
I'm probably closest to the one, trying to fix reported bugs when I have
time... Also Marcin Slusarz has done some cleanup work recently (his
patches are in -mm kernel and will go into mainline kernel soon - probably
into 2.6.25 - I'm afraid you'll have to rediff your patch against his
patches).
  Anyway, for submitting a patch, you can use guidelines in
Documentation/SubmittingPatches. Especially, your patch has to have some
description and Signed-off-by line. I can then review the patch when you
submit it.
  BTW: I've just quickly browsed through the patch and I don't quite get
why have you commented out UDF_SB_SESSION() in udf_read_tagged(). Also even
if it really shouldn't be there, then just delete it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
