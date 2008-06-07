Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbYFGXg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbYFGXg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 19:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbYFGXgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 19:36:45 -0400
Received: from ns1.suse.de ([195.135.220.2]:50332 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595AbYFGXgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 19:36:23 -0400
Date: Sun, 8 Jun 2008 01:36:40 +0200
From: Holger Macht <hmacht@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Pavel Machek <pavel@suse.cz>, auke-jan.h.kok@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       len.brown@intel.com, cpufreq@lists.linux.org.uk,
       davej@codemonkey.org.uk
Subject: Re: bug? acpi p-state + ondemand keeps dropping max freq
Message-ID: <20080607233640.GA9266@homac>
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	Pavel Machek <pavel@suse.cz>, auke-jan.h.kok@intel.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	len.brown@intel.com, cpufreq@lists.linux.org.uk,
	davej@codemonkey.org.uk
References: <20080606140846.GA9580@ucw.cz> <20080607213918.GC1746@elf.ucw.cz> <20080607145435.4afc9812@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080607145435.4afc9812@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 07. Jun - 14:54:35, Arjan van de Ven wrote:
> On Sat, 7 Jun 2008 23:39:18 +0200
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > > # echo 1866000 > scaling_max_freq ; cat scaling_max_freq
> > > 800000
> > > # echo 1866000 > scaling_max_freq ; cat scaling_max_freq
> > > 800000
> > > 
> > > 
> > > This renders my Dothan to utterly poor speeds. (standard T43)
> > > 
> > > performance cpufreq governor makes no difference - I still can't
> > > change the frequency upper/lower values.
> > 
> > Hmm, I have similar problem in Novell bugzilla, on very different hw:
> > 
> > https://bugzilla.novell.com/show_bug.cgi?id=396311
> > 
> > 								Pavel
> > 
> 
> 
> are either of you running gnome-power-manager or kpowersaved ?
> sometimes these programs (and more likely, the patches added by a
> distro maintainer who doesn't fully realize how power works) tend to
> muck with kernel settings around CPU frequency that they have
> absolutely no business touching...

I'm not aware of any 'brand' of kpowersave or gnome-power-manager which
could interfere here. Nor I'm aware of any backends in recent distros
which tweak the 'max freq' knobs. So I don't think this can be related. Or
please be a little bit more detailed about what you're referring to...

Regards,
	Holger
