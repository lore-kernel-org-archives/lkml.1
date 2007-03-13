Return-Path: <linux-kernel-owner+w=401wt.eu-S932149AbXCMSuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbXCMSuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 14:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbXCMSuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 14:50:16 -0400
Received: from styx.suse.cz ([82.119.242.94]:42693 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932149AbXCMSuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 14:50:14 -0400
Date: Tue, 13 Mar 2007 19:55:54 +0100
From: Jan Kara <jack@suse.cz>
To: Ashif Harji <asharji@cs.uwaterloo.ca>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: do_generic_mapping_read performance issue
Message-ID: <20070313185554.GA5105@duck.suse.cz>
References: <Pine.GSO.4.64.0703081612290.1080@cpu102.cs.uwaterloo.ca> <20070312142012.GH30777@atrey.karlin.mff.cuni.cz> <20070312143900.GB6016@wotan.suse.de> <20070312151355.GB23532@duck.suse.cz> <Pine.GSO.4.64.0703121247210.7679@cpu102.cs.uwaterloo.ca> <20070312173500.GF23532@duck.suse.cz> <Pine.GSO.4.64.0703131438580.8193@cpu102.cs.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.0703131438580.8193@cpu102.cs.uwaterloo.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 13-03-07 14:43:47, Ashif Harji wrote:
> 
> >>I would like to submit a patch to fix the performance problem.  The
> >>simplest solution is to remove the check.  Even in the situation where an
> >>application does not read in PAGE_SIZE multiples as described above, if
> >>the page is accessed frequently it should remain in the cache.  However, I
> >>am open to suggestions for a more sophisticated scheme.
> >
> > Well, yes, that's an obvious solution. I just wanted to make sure that
> >such change won't break some other load. But so far it seems it won't...
> 
> I would like to find out if the change I am suggesting will cause any 
> other problems.  Is there someone else I should contact before submitting 
> a patch?  Or should I just wait another day or two for comments?
  I don't think you'll get more feedback now. Just write the patch,
benchmark it with your workload and also some others (basically, there should be
no difference) and then submit the patch together with the performance
numbers and some rationale (if it's your first submission, see
Documentation/SubmittingPatches). Give also CC to Andrew <akpm@linux-foundation.org>
and ask him to put it into -mm kernels for testing.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
