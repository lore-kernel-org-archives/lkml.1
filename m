Return-Path: <linux-kernel-owner+w=401wt.eu-S1759221AbYFQSQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221AbYFQSQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 14:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYFQSQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 14:16:09 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:34834 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbYFQSQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 14:16:07 -0400
Date: Tue, 17 Jun 2008 14:15:38 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: bug? acpi p-state + ondemand keeps dropping max freq
In-reply-to: <20080616104159.GA28659@elf.ucw.cz>
X-X-Sender: lenb@localhost.localdomain
To: Pavel Machek <pavel@suse.cz>
Cc: Arjan van de Ven <arjan@infradead.org>, auke-jan.h.kok@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       len.brown@intel.com, cpufreq@lists.linux.org.uk,
       davej@codemonkey.org.uk
Message-id: <alpine.LFD.1.10.0806171404370.7277@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20080606140846.GA9580@ucw.cz> <20080607213918.GC1746@elf.ucw.cz>
 <20080607145435.4afc9812@infradead.org> <20080616104159.GA28659@elf.ucw.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



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
> > > Hmm, I have similar problem in Novell bugzilla, on very different hw:
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

Thanks for the pointer to the novell report, Pavel.
I poked at that one and I think it may actually be a table loading issue
for which we've just send a patch to 2.6.26.

Auke,

Please open a signting in bugzilla and attach your dmesg and 
acpidump output.

Also, please report if processor.ignore_ppc=1 helps.

http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI

thanks,
-Len

