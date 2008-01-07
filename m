Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbYAGQiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbYAGQiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757876AbYAGQhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:37:51 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:57513 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756328AbYAGQhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:37:50 -0500
Date: Mon, 7 Jan 2008 17:37:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Rename suspend/hibernation stuff for clarity
Message-ID: <20080107163736.GC16072@uranus.ravnborg.org>
References: <20080107135236.GA17140@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107135236.GA17140@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 02:52:36PM +0100, Pavel Machek wrote:
> kernel/suspend_64.c and power/cpu.c were equivalent. Move them into
> power/cpu_*.c for consistency.
> 
> power/swsusp.S and kernel/suspend_asm_64.S were both misnamed and
> equivalent. Merge then minto power/hibernation_*.S.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> ---
> commit 2a4fbaecebafff5b3114d0e87ecf73c45bc57f7b
> tree a13462c0ae1fa640a9b9d08cfea0bf6056b26385
> parent eafb847ccc4f73c2737157b510dcf7b040f53147
> author Pavel <pavel@amd.ucw.cz> Mon, 07 Jan 2008 14:50:25 +0100
> committer Pavel <pavel@amd.ucw.cz> Mon, 07 Jan 2008 14:50:25 +0100
> 
>  arch/x86/Makefile_64             |    1 
>  arch/x86/kernel/Makefile_64      |    2 
>  arch/x86/kernel/suspend_64.c     |  294 --------------------------------------
>  arch/x86/kernel/suspend_asm_64.S |  141 ------------------
>  arch/x86/power/Makefile          |   10 +
>  arch/x86/power/cpu.c             |  133 -----------------
>  arch/x86/power/cpu_32.c          |  133 +++++++++++++++++
>  arch/x86/power/cpu_64.c          |  294 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/power/hibernation_32.S  |   78 ++++++++++
>  arch/x86/power/hibernation_64.S  |  141 ++++++++++++++++++
>  arch/x86/power/swsusp.S          |   78 ----------
>  11 files changed, 655 insertions(+), 650 deletions(-)

git diff -C -M -B  (IIRC) gives a much more readable diffstat.
They works for git format-patch and friends too.

	Sam
