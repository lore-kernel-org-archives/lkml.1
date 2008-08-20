Return-Path: <linux-kernel-owner+w=401wt.eu-S1760411AbYHTQ5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411AbYHTQ5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbYHTQ47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:56:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4887 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753480AbYHTQ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:56:59 -0400
Date: Wed, 20 Aug 2008 18:44:36 +0200
From: Pavel Machek <pavel@suse.cz>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 2/6] Container Freezer: uninline thaw_process()
Message-ID: <20080820164435.GB7686@ucw.cz>
References: <20080819232232.432973784@us.ibm.com> <20080819232233.732140572@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819232233.732140572@us.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-08-19 16:22:34, Matt Helsley wrote:
> Now that the cgroup freezer system also calls thaw_process() inlining these
> functions uses more space. Uninlining returns some space:
> 
> Before:
> 	text	data	bss	dec	hex	filename
> 	4260872	275532	290816	4827220 49a854	vmlinux
> After:
> 	text	data	bss	dec	hex	filename
> 	4260852	275532	290816	4827200	49a840	vmlinux


20 bytes...

Does it still compile out if freezer is disabled?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
