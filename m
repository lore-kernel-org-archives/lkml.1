Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZBCNKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZBCNKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbZBCNKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:10:03 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50772 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbZBCNKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:10:01 -0500
Date: Fri, 30 Jan 2009 21:22:20 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       srostedt@redhat.com
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
Message-ID: <20090130202219.GA1253@ucw.cz>
References: <497F69A4.2070007@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497F69A4.2070007@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-01-27 12:08:04, Kok, Auke wrote:
> 
> This tracer monitors regular file open() syscalls. This is a fast
> and low-overhead alternative to strace, and does not allow or
> require to be attached to every process.
> 
> The tracer only logs succesfull calls, as those are the only ones we
> are currently interested in, and we can determine the absolute path
> of these files as we log.

Maybe fanotify() should be used instead?

Or maybe just plain strace? One slow boot should not really hurt...
								Pavel
 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
