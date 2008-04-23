Return-Path: <linux-kernel-owner+w=401wt.eu-S933847AbYDWAzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847AbYDWAzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 20:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698AbYDWAys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 20:54:48 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:45797 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbYDWAyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 20:54:41 -0400
Date: Tue, 22 Apr 2008 20:54:38 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Domenico Andreoli <cavokz@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-parisc@vger.kernel.org
Subject: Re: [REGRESSION] 2.6.25 on parisc - CPU 1 is stuck
Message-ID: <20080423005438.GK19802@phobos.i.cabal.ca>
References: <20080420231818.GA2162@ska.dandreoli.com> <1208789018.3640.6.camel@localhost.localdomain> <20080423004440.GB21544@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423004440.GB21544@colo.lackof.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 06:44:40PM -0600, Grant Grundler wrote:
> 
> *nod* I don't expect CPUs to show up in inventory if they are
> deconfigured in BCH. Maybe J-class firmware has this wrong? *shrug*
> Something worth checking I guess.
> 

i booted the kernel from my rp3440 on my j6000. i also get this cpu1 is
stuck message. putting a panic in the SMP C-code entrypoint is never
hit.

most oddly, putting a hpmc-causing insn sequence in the entry point
doesn't trigger either, so the cpu isn't coming out of the rendezvous.

even more oddly, the stwa insn in the bring up code looks fine.

--kyle
