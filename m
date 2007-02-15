Return-Path: <linux-kernel-owner+w=401wt.eu-S1946115AbXBPUP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946115AbXBPUP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946114AbXBPUP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:15:57 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1412 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946110AbXBPUP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:15:56 -0500
Date: Thu, 15 Feb 2007 22:13:04 +0000
From: Pavel Machek <pavel@ucw.cz>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@osdl.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, davej@redhat.com, arjan@infradead.org,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Message-ID: <20070215221304.GB6602@ucw.cz>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Now, this is not a complete solution by any means: the core kernel is not
> protected, and nor are /dev/mem or /dev/kmem, but it denies (or at least
> controls) one relatively simple attack vector.

Could we fix the /dev/*mem holes, first? They are already used by
malicious modules (aka rootkits...).  Or can selinux already provide
/dev/*mem protection with no way for admin to turn it off?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
