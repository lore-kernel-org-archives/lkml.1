Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbYFPOn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbYFPOn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYFPOnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:43:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:48971 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbYFPOns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:43:48 -0400
Date: Mon, 16 Jun 2008 07:43:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@suse.cz>
Cc: auke-jan.h.kok@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, len.brown@intel.com,
       cpufreq@lists.linux.org.uk, davej@codemonkey.org.uk
Subject: Re: bug? acpi p-state + ondemand keeps dropping max freq
Message-ID: <20080616074337.46d6f411@infradead.org>
In-Reply-To: <20080616104159.GA28659@elf.ucw.cz>
References: <20080606140846.GA9580@ucw.cz>
	<20080607213918.GC1746@elf.ucw.cz>
	<20080607145435.4afc9812@infradead.org>
	<20080616104159.GA28659@elf.ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008 12:42:00 +0200
Pavel Machek <pavel@suse.cz> wrote:

> On Sat 2008-06-07 14:54:35, Arjan van de Ven wrote:
> > On Sat, 7 Jun 2008 23:39:18 +0200
> > Pavel Machek <pavel@suse.cz> wrote:
> > 
> > > > # echo 1866000 > scaling_max_freq ; cat scaling_max_freq
> > > > 800000
> > > > # echo 1866000 > scaling_max_freq ; cat scaling_max_freq
> > > > 800000
> > > > 
> > > > 
> > > > This renders my Dothan to utterly poor speeds. (standard T43)
> > > > 
> > > > performance cpufreq governor makes no difference - I still can't
> > > > change the frequency upper/lower values.
> > > 
> > > Hmm, I have similar problem in Novell bugzilla, on very different
> > > hw:
> > > 
> > > https://bugzilla.novell.com/show_bug.cgi?id=396311
> 
> > are either of you running gnome-power-manager or kpowersaved ?
> > sometimes these programs (and more likely, the patches added by a
> > distro maintainer who doesn't fully realize how power works) tend to
> > muck with kernel settings around CPU frequency that they have
> > absolutely no business touching...
> 
> In novel bugzilla case ignore_ppc=1 helped, so it seems to be BIOS
> problem, not userland's...

well as long as the user doesn't use this for production use... the
BIOS often reduces frequencies available to deal with thermal
situations, so it's not a good idea to ignore that.
