Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbZGJMGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbZGJMGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbZGJMFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:05:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53343 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbZGJMFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:05:25 -0400
Date: Fri, 10 Jul 2009 01:19:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "John A. Gregor" <john.gregor@qlogic.com>, ralph.campbell@qlogic.com,
       linux-kernel@vger.kernel.org, johng@diamond.mv.qlogic.com
Subject: Re: [PATCH] x86_64/__iowrite32_copy: don't use string move for PIO
	writes
Message-ID: <20090709231957.GC1469@ucw.cz>
References: <1246907224-22758-1-git-send-email-john.gregor@qlogic.com> <4A526CE6.30200@zytor.com> <4a526e77.IPiyTZWRWfll2+00%john.gregor@qlogic.com> <4A527EE4.1080102@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A527EE4.1080102@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> - the current code is fine as long as it doesn't cross from cached to
>   uncached memory, which it never should in any kind of sensible driver;

Should we add a comment somewhere saying that is not permitted (and why)?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
