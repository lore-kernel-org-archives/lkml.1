Return-Path: <linux-kernel-owner+w=401wt.eu-S1752708AbZHBMue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbZHBMue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 08:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZHBMuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 08:50:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47893 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbZHBMub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 08:50:31 -0400
Date: Thu, 30 Jul 2009 11:07:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ludwig Nussel <ludwig.nussel@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] implement uid mount option for ext2 and ext3
Message-ID: <20090730090659.GC1364@ucw.cz>
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de> <10655.1248384221@turing-police.cc.vt.edu> <200907241223.58220.ludwig.nussel@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907241223.58220.ludwig.nussel@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Hint:  This *same exact* problem has been an issue for NFS for at least 25
> > years. Might want to think about (a) why Yellow Pages (and later LDAP) was
> > developed, and (b) why NFS "root squash" traditionally maps to "nobody" rather
> > than a usable UID.
> 
> I don't see how that helps us here. Sure, a uid != 0 could be used
> for the mapping but which one? The uid of user 'nobody' is not the
> same across distros.

So just use -1 ? Having it map to root is dangerous AFAICT.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
