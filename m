Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYCMSFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYCMSFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 14:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbYCMSFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 14:05:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54535 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbYCMSFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 14:05:22 -0400
Date: Thu, 13 Mar 2008 19:05:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: pm_register() and pm_send_all()
Message-ID: <20080313180558.GC4949@elf.ucw.cz>
References: <20080312150042.96668bcd.akpm@linux-foundation.org> <21968.1205411497@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21968.1205411497@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-13 12:31:37, David Howells wrote:
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > pm_send_all() has just a handful of callers:
> 
> What should be done instead of calling pm_send_all()?

pm_send_all is currently nop.

device_suspend/resume are closest equivalents. 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
