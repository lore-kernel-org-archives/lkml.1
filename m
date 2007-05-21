Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbXEUNre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbXEUNre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 09:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbXEUNr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 09:47:26 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:44133 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbXEUNrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 09:47:24 -0400
Date: Mon, 21 May 2007 14:45:53 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>, trenn@suse.de,
       Chuck Ebbert <cebbert@redhat.com>, len.brown@intel.com,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
Message-ID: <20070521134553.GA7911@srcf.ucam.org>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <200705171517.14087.lenb@kernel.org> <1179604609.16465.83.camel@sublime.suse.de> <200705202350.45145.lenb@kernel.org> <20070521121048.GA8332@elf.ucw.cz> <20070521132711.GA7540@srcf.ucam.org> <20070521132948.GD8332@elf.ucw.cz> <20070521133608.GB7540@srcf.ucam.org> <20070521134046.GE8332@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521134046.GE8332@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 03:40:46PM +0200, Pavel Machek wrote:
> On Mon 2007-05-21 14:36:08, Matthew Garrett wrote:
> > On Mon, May 21, 2007 at 03:29:48PM +0200, Pavel Machek wrote:
> > > Significantly more correct? It forces you to do all the thermal
> > > management in userspace!
> > 
> > Why's that a problem? 
> 
> Duplicating all the kernel logic in userspace, badly?

So don't do it badly. The advantage of doing so is that you can make it 
work properly, which you can't by putting it in the kernel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
