Return-Path: <linux-kernel-owner+w=401wt.eu-S1764224AbYESWex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764224AbYESWex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbYESWej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:34:39 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43938 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbYESWei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:34:38 -0400
Date: Tue, 20 May 2008 01:32:32 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] asm-generic/int-ll64.h: always provide __{s,u}64
Message-ID: <20080519223232.GB17716@cs181133002.pp.htv.fi>
References: <20080519215452.GK17716@cs181133002.pp.htv.fi> <4831F89F.5060106@zytor.com> <1211236048.5915.94.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1211236048.5915.94.camel@brick>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 03:27:28PM -0700, Harvey Harrison wrote:
> On Mon, 2008-05-19 at 15:01 -0700, H. Peter Anvin wrote:
> > Adrian Bunk wrote:
> > > Several compilers offer "long long" without claiming to support C99.
> > > 
> > > Considering how frequent __s64/__u64 are used our userspace headers are 
> > > anyway unusable without __s64/__u64 available.
> > > 
> > > Always offer __s64/__u64 to non-gcc non-C99 compilers - if they provide 
> > > "long long" that makes the headers compiling and if they don't they are 
> > > anyway screwed.
> > > 
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > This makes sense to me (I did, however, not want to make that change 
> > part of the same changeset - one change at a time.)
> > 
> > The main reason for not just blindly using "long long" has to do with 
> > the use of gcc -ansi -pedantic in userspace, which is already taken care 
> > of by the use of __extension__ in the __GNUC__ clause.
> > 
> 
> If it is going to be unconditionally offered, we could get rid of
> __BYTEORDER_HAS_U64__ as a next step.  Unless there is something I've
> missed.

Why do we need the byteorder headers in userspace at all?

> Harvey

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

