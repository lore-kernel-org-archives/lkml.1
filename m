Return-Path: <linux-kernel-owner+w=401wt.eu-S1764631AbYDQMiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764631AbYDQMiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 08:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbYDQMil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 08:38:41 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53777 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYDQMik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 08:38:40 -0400
Date: Thu, 17 Apr 2008 06:38:17 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Adrian Bunk <bunk@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [2.6 patch] ARM: always select HAVE_IDE
Message-ID: <20080417123816.GA20637@parisc-linux.org>
References: <20080414141659.GF6695@cs181133002.pp.htv.fi> <20080415221002.GL1677@cs181133002.pp.htv.fi> <20080415223928.GH5676@flint.arm.linux.org.uk> <200804160126.11116.bzolnier@gmail.com> <20080417093753.GF1677@cs181133002.pp.htv.fi> <20080417095916.GD1449@flint.arm.linux.org.uk> <20080417104836.GH1677@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417104836.GH1677@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 01:48:36PM +0300, Adrian Bunk wrote:
> avr32 is fixed in 2.6.25 (no more HAVE_IDE)
> m68knommu I'll check
> ppc arch will be removed in 2 months

More pertinently, builds using ARCH=ppc will use asm-powerpc via a nasty
nasty temporary hack ;-)

> v850 arch is completely hosed, and I'm already trying to get it removed

Oh good.  There's a couple of things I've noticd about it recently that
are broken and was trying to summon the enthusiasm for doing a proper
bug report.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
