Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbZB0N1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbZB0N1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 08:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbZB0N1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 08:27:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41844 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbZB0N1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 08:27:09 -0500
Date: Fri, 27 Feb 2009 14:26:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] filesystem: VMUFAT filesystem
Message-ID: <20090227132658.GC1482@ucw.cz>
References: <1234646219.6609.37.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234646219.6609.37.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

> +	do {
> +		/* Have we got a file? */
> +		if (((__u8 *)bh->b_data)[(fno % 0x10) * 0x20] == 0) {

u8 should be ok, no need for underscores. Applies to whole file.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
