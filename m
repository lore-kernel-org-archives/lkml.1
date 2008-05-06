Return-Path: <linux-kernel-owner+w=401wt.eu-S932379AbYEFQcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbYEFQcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932256AbYEFQcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:32:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:13708 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbYEFQcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:32:19 -0400
Date: Tue, 6 May 2008 18:32:06 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-parisc@vger.kernel.org
Subject: Re: [REGRESSION] 2.6.25 on parisc - CPU 1 is stuck
Message-ID: <20080506163206.GA2211@ska.dandreoli.com>
Mail-Followup-To: Kyle McMartin <kyle@mcmartin.ca>,
	Grant Grundler <grundler@parisc-linux.org>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-parisc@vger.kernel.org
References: <20080420231818.GA2162@ska.dandreoli.com> <1208789018.3640.6.camel@localhost.localdomain> <20080423004440.GB21544@colo.lackof.org> <20080423005438.GK19802@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423005438.GK19802@phobos.i.cabal.ca>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 08:54:38PM -0400, Kyle McMartin wrote:
> On Tue, Apr 22, 2008 at 06:44:40PM -0600, Grant Grundler wrote:
> > 
> > *nod* I don't expect CPUs to show up in inventory if they are
> > deconfigured in BCH. Maybe J-class firmware has this wrong? *shrug*
> > Something worth checking I guess.
> > 
> 
> i booted the kernel from my rp3440 on my j6000. i also get this cpu1 is
> stuck message. putting a panic in the SMP C-code entrypoint is never
> hit.
> 
> most oddly, putting a hpmc-causing insn sequence in the entry point
> doesn't trigger either, so the cpu isn't coming out of the rendezvous.
> 
> even more oddly, the stwa insn in the bring up code looks fine.

still nothing changed with 2.6.26-rc1-00110-ga153063

cheers,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
