Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbZAKTCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbZAKTCB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbZAKTBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:01:45 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58356 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZAKTBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:01:44 -0500
Date: Sun, 11 Jan 2009 19:39:36 +0100
From: Pavel Machek <pavel@suse.cz>
To: Mike Travis <travis@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Cliff Wickman <cpw@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [patch] x86: make UV support optional
Message-ID: <20090111183935.GC2217@ucw.cz>
References: <20090106060348.GA16738@wotan.suse.de> <20090106143330.GB18913@sgi.com> <20090106144843.GH16738@wotan.suse.de> <49637346.6060105@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49637346.6060105@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The problem arises that if the option becomes too obscure (and never
> enabled), then it won't get tested.  We (as many companies do) rely on
> distros to certify applications and security features using a standard
> kernel, and if an option (such as X86_UV) causes any problems whatsoever,
> they'll drop it and we no longer have that application certification.

If SGI UV is really important, I'm sure you can ask distros to keep it
enabled.


> Currently, Ingo's test setup sets MAXSMP quite a bit and he's found
> many problems with large NR_CPUS counts that we never would have found
> ourselves.  Please don't make that process any harder.

Yeah, and remove config_386 too. Just hardcode it to y.

No, sorry, I don't see why we should treat UV specially.

> In fact, 13k is peanuts.  Why don't you set something like "very minimal

13K is quite a lot, actually.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
