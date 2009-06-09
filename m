Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbZFIHc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbZFIHc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758883AbZFIHcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:32:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758881AbZFIHcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:32:03 -0400
Subject: Re: [PATCH] x86: clean up vdso-layout.lds.S
From: Petr Tesarik <ptesarik@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <4A2946B9.3070701@zytor.com>
References: <1243865115.24278.8.camel@nathan.suse.cz>
	 <1244215559.1604.12.camel@nathan.suse.cz>
	 <20090605162738.GI1065@one.firstfloor.org>  <4A2946B9.3070701@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Tue, 09 Jun 2009 09:32:12 +0200
Message-Id: <1244532732.5199.29.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin píše v Pá 05. 06. 2009 v 09:24 -0700:
> Andi Kleen wrote:
> >> Any comments on this? It doesn't change anything. It only makes it
> >> harder to break vDSOs by accident (such as the latest buglet with TSC
> >> synchronization).
> > 
> > Looks ok to me. Although it would have been nicer if you hadn't mixed
> > that many changes together.
> > 
> > Acked-by: Andi Kleen <ak@linux.intel.com>
> > 
> 
> It would have.  That makes review harder, and right at the moment time
> is a bit at a premium.  It looks like a good cleanup, but it also looks
> like it's going to need some testing, which means that since it is not a
> functional change I would feel best if we could put it on the .32 track
> after the imminent merge window craziness is over.

You're right. It doesn't make any functional change, so I'm completely
fine with taking it on the .32 track.

For the time being, please hold on, as I'm going to split the patch into
a series to make reviewing easier. But to be honest, the current content
of vdso-layout.lds.S is such mess that I'm convinced it must have been
done in a big hurry (and then moved around a few times, so a quick
glance at git-blame doesn't tell you that the most messy pieces have
been there since the very beginning).

Petr Tesarik


