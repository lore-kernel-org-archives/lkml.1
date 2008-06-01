Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYFATxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYFATxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 15:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYFATxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 15:53:32 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:40570 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYFATxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 15:53:31 -0400
Date: Sun, 1 Jun 2008 22:53:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>, sam@ravnborg.org, hjl.tools@gmail.com,
       linux-kbuild@vger.kernel.org, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: sh64 build error - sh, kbuild or binutils problem?
Message-ID: <20080601195306.GD7347@cs181133002.pp.htv.fi>
References: <20080531202239.GB7347@cs181133002.pp.htv.fi> <20080601053047.GA25429@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080601053047.GA25429@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 02:30:47PM +0900, Paul Mundt wrote:
> On Sat, May 31, 2008 at 11:22:39PM +0300, Adrian Bunk wrote:
> > Minimal example demonstrating the problem:
> > 
> > $ sh64-linux-ar rcs tmp.o
> > $ sh64-linux-ld -EL -r -o tmp2.o tmp.o
> > $ sh64-linux-ld -EL -r -o out.o tmp2.o 
> > sh64-linux-ld: sh3 architecture of input file `tmp2.o' is incompatible with sh5 output
> > $ 
> > 
> Yes, it's a binutils bug. I've hit this on SH-2A zImage builds too, and
> hacked together a patch for it. I'll see about fixing it up fo sh64 too
> and then posting it to the list.

Thanks  :-)
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

