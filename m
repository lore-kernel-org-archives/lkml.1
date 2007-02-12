Return-Path: <linux-kernel-owner+w=401wt.eu-S964901AbXBLPFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964901AbXBLPFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 10:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964957AbXBLPFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 10:05:48 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49426 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964901AbXBLPFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 10:05:47 -0500
Date: Mon, 12 Feb 2007 16:05:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <ak@suse.de>
Cc: Oliver Neukum <oneukum@suse.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [PATCH x86 for review II] [18/39] x86_64: Allow to run a program when a machine check event is detected
Message-ID: <20070212150522.GB17400@elf.ucw.cz>
References: <20070212837.963446000@suse.de> <20070212073805.89FEE13D7F@wotan.suse.de> <200702120854.15814.oneukum@suse.de> <200702120904.43287.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702120904.43287.ak@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-02-12 09:04:43, Andi Kleen wrote:
> On Monday 12 February 2007 08:54, Oliver Neukum wrote:
> > Am Montag, 12. Februar 2007 08:38 schrieb Andi Kleen:
> > > When a machine check event is detected (including a AMD RevF threshold 
> > > overflow event) allow to run a "trigger" program. This allows user space
> > > to react to such events sooner.
> > 
> > Could this not be merged with other reporting mechanisms? This looks like
> > a new incarnation of the /etc/hotplug code.
> 
> I refuse to make mcelog depend on dbus. Just because some desktops want bloat
> doesn't mean that everybody else wants too.

Hmm... fix the userspace, no? /etc/hotplug code in kernel should work
with other stuff than dbus...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
