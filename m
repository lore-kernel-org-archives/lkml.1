Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbYEFL00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbYEFL00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 07:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYEFL0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 07:26:17 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54469 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbYEFL0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 07:26:16 -0400
Date: Tue, 6 May 2008 14:25:05 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Alexander Viro <viro@ftp.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches
Message-ID: <20080506112505.GA2359@cs181133002.pp.htv.fi>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi> <20080505201906.GA900@elte.hu> <874p9ccmes.fsf@basil.nowhere.org> <20080506061825.GF1544@cs181133002.pp.htv.fi> <48203D3D.6000103@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48203D3D.6000103@firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 01:13:01PM +0200, Andi Kleen wrote:
> Adrian Bunk wrote:
> > On Tue, May 06, 2008 at 02:21:31AM +0200, Andi Kleen wrote:
>...
> >> I could see some advantage from static in future compiler versions 
> >> though from better optimization, but it's quite remote.
> >> ...
> > 
> > The best case I've actually seen in practice was a variable I made 
> > static, and with CONFIG_DEBUG_FOOBAR=n gcc was now able to prove that 
> > the value never changed resulting in the variable plus quite a chunk
> > of code no longer emitted.
> 
> Sounds like the variable should just have been removed then in the source?

No, an #ifdef CONFIG_DEBUG_FOOBAR guarded some sysctl that allows users 
to change the value.

(I'm not claiming this was a common case.)

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

