Return-Path: <linux-kernel-owner+w=401wt.eu-S1751241AbZERRNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbZERRNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZERRM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:12:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56360 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbZERRMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:12:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: [Bug #13178] Booting very slow
Date: Mon, 18 May 2009 19:13:08 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera> <pQ9WADCjgyE.A.scG.LA0DKB@chimera> <424718.52835.qm@web32607.mail.mud.yahoo.com>
In-Reply-To: <424718.52835.qm@web32607.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905181913.09048.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 May 2009, Martin Knoblauch wrote:
> 
> ----- Original Message ----
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> > Cc: Kernel Testers List <kernel-testers@vger.kernel.org>; Martin Knoblauch <spamtrap@knobisoft.de>
> > Sent: Saturday, May 16, 2009 10:06:02 PM
> > Subject: [Bug #13178] Booting very slow
> > 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.28 and 2.6.29.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=13178
> > Subject        : Booting very slow
> > Submitter    : Martin Knoblauch 
> > Date        : 2009-04-24 12:45 (23 days old)
> > References    : http://marc.info/?l=linux-kernel&m=124057716231773&w=4
> 
>  The issue is still open. It turns out that starting with 2.6.29-rc1 /proc/mounts already has a "sysfs" line when entering the startup scripts from initrd. This breaks the RHEL4 firmware hotplug script.
> 
> Simple fix to user space is available. I do not know how important this issue is.
> 
> Anyway, I am in the process of bisecting the problem. It is just a bit tedious in the my customers and employers environment :-(

Thanks a lot for doing this.

Best,
Rafael
