Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbYFWIRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbYFWIRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYFWIRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:17:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35558 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbYFWIRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:17:14 -0400
Date: Mon, 23 Jun 2008 10:18:11 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pcmcia@lists.infradead.org
Subject: Re: 2.6.26-rc6: pcmcia stopped working after resume
Message-ID: <20080623081811.GA1850@elf.ucw.cz>
References: <20080622224022.GA2066@elf.ucw.cz> <20080623081309.GA10820@isilmar.linta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623081309.GA10820@isilmar.linta.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > After s2ram and resume, CF card in PCMCIA-to-CF slot is no longer
> > detected.
> 
> might this be related to:
> http://bugzilla.kernel.org/show_bug.cgi?id=10957 ? There didn't change
> anything with regard to pcmcia between -rc3 and -rc6...

I'm pretty sure it worked in 2.6.25; I don't know if it worked in
-rc3, or not.

I don't even see note about card insertion in dmesg, so I figured out
it is probably pcmcia-core problem (or something deeper).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
