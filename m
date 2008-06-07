Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbYFGWNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbYFGWNd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 18:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYFGWNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 18:13:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52801 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbYFGWNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 18:13:23 -0400
Date: Sat, 7 Jun 2008 14:54:35 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@suse.cz>
Cc: pavel@suse.cz, auke-jan.h.kok@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, len.brown@intel.com,
       cpufreq@lists.linux.org.uk, davej@codemonkey.org.uk
Subject: Re: bug? acpi p-state + ondemand keeps dropping max freq
Message-ID: <20080607145435.4afc9812@infradead.org>
In-Reply-To: <20080607213918.GC1746@elf.ucw.cz>
References: <20080606140846.GA9580@ucw.cz>
	<20080607213918.GC1746@elf.ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jun 2008 23:39:18 +0200
Pavel Machek <pavel@suse.cz> wrote:

> > # echo 1866000 > scaling_max_freq ; cat scaling_max_freq
> > 800000
> > # echo 1866000 > scaling_max_freq ; cat scaling_max_freq
> > 800000
> > 
> > 
> > This renders my Dothan to utterly poor speeds. (standard T43)
> > 
> > performance cpufreq governor makes no difference - I still can't
> > change the frequency upper/lower values.
> 
> Hmm, I have similar problem in Novell bugzilla, on very different hw:
> 
> https://bugzilla.novell.com/show_bug.cgi?id=396311
> 
> 								Pavel
> 


are either of you running gnome-power-manager or kpowersaved ?
sometimes these programs (and more likely, the patches added by a
distro maintainer who doesn't fully realize how power works) tend to
muck with kernel settings around CPU frequency that they have
absolutely no business touching...


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
