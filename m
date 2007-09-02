Return-Path: <linux-kernel-owner+w=401wt.eu-S933616AbXIBG7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616AbXIBG7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 02:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbXIBG73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 02:59:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47396 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbXIBG72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 02:59:28 -0400
Date: Sun, 2 Sep 2007 08:59:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: the Linux kernel, testsuites, and maybe *you*
Message-ID: <20070902065926.GA15487@one.firstfloor.org>
References: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com> <p733axyxcli.fsf@bingen.suse.de> <8bd0f97a0709011550y833fb5ax7d40cae937789fd8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0709011550y833fb5ax7d40cae937789fd8@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2007 at 06:50:30PM -0400, Mike Frysinger wrote:
> On 02 Sep 2007 00:08:57 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> > BTW string functions are best tested in user space. That's
> > a relatively bad example.
> 
> in theory, maybe ... in reality, i really dont think so
> 
> the string implementations are spread out over the kernel ... there's
> implementations in lib/, include/asm-*/, and arch/*/lib/ ... so any
> test code that would use these sources is going to be an ugly hack to
> make sure it grabs all the right pieces from all the right places.

string functions tend to be self contained.

The other issue to test some of them properly you need unmapped pages
etc. That gets much easier to do in user space. There are some other
issues.

-Andi
