Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbYEFMaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbYEFMaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbYEFM34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:29:56 -0400
Received: from ns1.suse.de ([195.135.220.2]:42206 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbYEFM3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:29:55 -0400
Subject: Re: PNP: set IRQ index in sysfs "set irq" interface
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>, Adam M Belay <abelay@mit.edu>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200805050900.46521.bjorn.helgaas@hp.com>
References: <200805011539.58705.bjorn.helgaas@hp.com>
	 <481DBE81.8000608@keyaccess.nl>  <200805050900.46521.bjorn.helgaas@hp.com>
Content-Type: text/plain
Date: Tue, 06 May 2008 16:29:43 +0200
Message-Id: <1210084183.4802.29.camel@linux-2bdv.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-05 at 09:00 -0600, Bjorn Helgaas wrote:
> On Sunday 04 May 2008 07:47:45 am Rene Herman wrote:
> > But what I wanted to ask -- judging from my .gitconfig (as opposed to my 
> > memory) I haven't done anything special to get the -p (--show-c-function) 
> > functionality from git-diff. Do you do anything special to not get it? It 
> > really helps when looking at patches.
> 
> I agree, "--show-c-function" is often handy.  I use quilt, and it
> looks like it doesn't add that option by default.  I added a ~/.quiltrc
> containing 'QUILT_DIFF_OPTS="-p"', and it looks like that will do the
> trick.  Thanks for the tip.

QUILT_REFRESH_ARGS="--diffstat"
in .quiltrc
is also nice if you have huger patches.

    Thomas

