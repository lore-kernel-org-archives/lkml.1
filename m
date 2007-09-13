Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbXIMJNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbXIMJNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbXIMJNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:13:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:32895 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbXIMJNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:13:45 -0400
Date: Thu, 13 Sep 2007 11:13:45 +0200
From: Jan Kara <jack@suse.cz>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Brent Casavant <bcasavan@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: O_NOLINK for open()
Message-ID: <20070913091345.GB5125@atrey.karlin.mff.cuni.cz>
References: <92Haf-7z7-5@gated-at.bofh.it> <E1IValy-0000fU-Sd@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IValy-0000fU-Sd@be1.lrz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > However, it occurs to me that this problem goes away if there were
> > a method create a file in an unlinked state to begin with.  However
> > there does not appear to be any such mechanism in Linux's open()
> > interface.
> 
> Having no window for creating stale temp files is nice to have. We only
> need a clever fool to implement it.-) But since it's hard to get killed
> just in the right moment for having a stale temp file, there is very low
> interest for this feature.
  I don't think this is a problem. The file is simply created with link
count 0. As soon as the process closes the file, it gets deleted. So
there would be no stale files... Or did you mean anything else?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
