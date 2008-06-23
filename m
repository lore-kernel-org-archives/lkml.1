Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbYFWIa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbYFWIa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbYFWIat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:30:49 -0400
Received: from isilmar.linta.de ([213.133.102.198]:36717 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753641AbYFWIas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:30:48 -0400
Date: Mon, 23 Jun 2008 10:30:46 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pcmcia@lists.infradead.org
Subject: Re: 2.6.26-rc6: pcmcia stopped working after resume
Message-ID: <20080623083046.GA12849@isilmar.linta.de>
Mail-Followup-To: Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-pcmcia@lists.infradead.org
References: <20080622224022.GA2066@elf.ucw.cz> <20080623081309.GA10820@isilmar.linta.de> <20080623081811.GA1850@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623081811.GA1850@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 10:18:11AM +0200, Pavel Machek wrote:
> Hi!
> 
> > > After s2ram and resume, CF card in PCMCIA-to-CF slot is no longer
> > > detected.
> > 
> > might this be related to:
> > http://bugzilla.kernel.org/show_bug.cgi?id=10957 ? There didn't change
> > anything with regard to pcmcia between -rc3 and -rc6...
> 
> I'm pretty sure it worked in 2.6.25; I don't know if it worked in
> -rc3, or not.
> 
> I don't even see note about card insertion in dmesg, so I figured out
> it is probably pcmcia-core problem (or something deeper).

Well, even since 2.6.25 not much changed in PCMCIA-land, so...

Best,
	Dominik
