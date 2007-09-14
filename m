Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbXINJIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbXINJIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 05:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbXINJHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 05:07:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:54771 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbXINJHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 05:07:51 -0400
Date: Fri, 14 Sep 2007 11:07:37 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Jan Kara <jack@suse.cz>
cc: Bodo Eggert <7eggert@gmx.de>, Brent Casavant <bcasavan@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: O_NOLINK for open()
In-Reply-To: <20070913091345.GB5125@atrey.karlin.mff.cuni.cz>
Message-ID: <Pine.LNX.4.58.0709141106160.2496@be1.lrz>
References: <92Haf-7z7-5@gated-at.bofh.it> <E1IValy-0000fU-Sd@be1.lrz>
 <20070913091345.GB5125@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+uqKk5NpGO/d8L+G7X4mzlUMTpMb2Vt8nH6CJ
 NI3zTokrgLacSCBOLeFKNfnn8eoiD+lam/FAlqxL2ubTw8AgBC
 GKcCeDfs0ywCxJxCrsQkQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007, Jan Kara wrote:

> > > However, it occurs to me that this problem goes away if there were
> > > a method create a file in an unlinked state to begin with.  However
> > > there does not appear to be any such mechanism in Linux's open()
> > > interface.
> > 
> > Having no window for creating stale temp files is nice to have. We only
> > need a clever fool to implement it.-) But since it's hard to get killed
> > just in the right moment for having a stale temp file, there is very low
> > interest for this feature.

>   I don't think this is a problem. The file is simply created with link
> count 0. As soon as the process closes the file, it gets deleted. So
> there would be no stale files... Or did you mean anything else?

This feature does, AFAIK, not yet exist. Therefore we'd need a code monkey.
-- 
Top 100 things you don't want the sysadmin to say:
42. Hey Fred, did you save that posting about restoring filesystems
    with vi and a toothpick?  More importantly, did you print it out?
