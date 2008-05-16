Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbYEPMMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbYEPMMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 08:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYEPMMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 08:12:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:38641 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbYEPMMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 08:12:35 -0400
Date: Fri, 16 May 2008 14:13:28 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
Message-ID: <20080516121328.GD22264@elf.ucw.cz>
References: <1204773188.4707.109.camel@caritas-dev.intel.com> <20080514205204.GJ30469@redhat.com> <1210818762.23707.102.camel@caritas-dev.intel.com> <20080515200923.GC9718@redhat.com> <1210902514.23707.161.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210902514.23707.161.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-05-16 09:48:34, Huang, Ying wrote:
> On Thu, 2008-05-15 at 16:09 -0400, Vivek Goyal wrote:
> [...]
> > Ok, You want to make BIOS calls. We already do that using vm86 mode and
> > use bios real mode interrupts. So why do we need this interface? Or, IOW,
> > how is this interface better?
> 
> It can call code in 32-bit physical mode in addition to real mode. So It
> can be used to call EFI runtime service, especially call EFI 64 runtime
> service under 32-bit kernel or vice versa.
> 
> The main purpose of kexec jump is for hibernation. But I think if the
> effort is small, why not support general 32-bit physical mode code call
> at same time.

I believe we should focus on kexecing kernels, first.

Only way to prove the effort is small is by having small followup
patch, and that needs the two patches separated...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
