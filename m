Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYHMHsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYHMHsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 03:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYHMHru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 03:47:50 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37104 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbYHMHrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 03:47:49 -0400
Date: Wed, 13 Aug 2008 08:55:42 +0200
From: Pavel Machek <pavel@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] suspend: fix section mismatch warning -
	register_nosave_region
Message-ID: <20080813065542.GA1813@elf.ucw.cz>
References: <1218576186-31442-4-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218576186-31442-4-git-send-email-marcin.slusarz@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-08-12 23:23:06, Marcin Slusarz wrote:
> WARNING: vmlinux.o(.text+0xe684): Section mismatch in reference from the function register_nosave_region() to the function .init.text:__register_nosave_region()
> The function register_nosave_region() references
> the function __init __register_nosave_region().
> This is often because register_nosave_region lacks a __init
> annotation or the annotation of __register_nosave_region is wrong.
> 
> register_nosave_region calls __init function and is called only from __init functions
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Pavel Machek <pavel@suse.cz>
> Cc: Len Brown <len.brown@intel.com>

You probably want to send it to akpm and/or Andi Kleen: Len is on
holidays.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
