Return-Path: <linux-kernel-owner+w=401wt.eu-S1760468AbYE0X7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760468AbYE0X7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 19:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYE0X7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 19:59:09 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:42811 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902AbYE0X7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 19:59:08 -0400
Date: Wed, 28 May 2008 02:56:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mirco Tischler <mt-ml@gmx.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [BUG: 2.6.26-rc3] ERROR: "____ilog2_NaN" undefined
Message-ID: <20080527235619.GI11310@cs181133002.pp.htv.fi>
References: <1211735607.14556.14.camel@mtlp.tischlernetz> <20080525181118.GG1791@cs181133002.pp.htv.fi> <1211742202.14556.25.camel@mtlp.tischlernetz> <20080525201807.GK1791@cs181133002.pp.htv.fi> <1211749036.16921.16.camel@mtlp.tischlernetz> <20080525210329.GN1791@cs181133002.pp.htv.fi> <1211752151.16921.25.camel@mtlp.tischlernetz> <1211836606.10718.18.camel@mtlp.tischlernetz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1211836606.10718.18.camel@mtlp.tischlernetz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 11:16:46PM +0200, Mirco Tischler wrote:
> Ok. Situation has changed. I discovered I'm still more dumb than I
> thought I am;). There was that link /usr/local/bin/gcc to the gcc-4.4pre
> executable that I didn't thought of.

Ah, that explains why only you were seeing it.

> the ver_linux script didn't check
> that too.

I'm wondering why it sets PATH - it would have saved us some time if it 
didn't.

I'll look at this.

> So the error only occurs with gcc-4.4. But my version is some
> weeks old so I'm currently compiling a fresh svn version to check if the
> error still exists.
> 
> I also found the config option that causes the error: enabling
> OPTIMIZE_FOR_SIZE and thus setting -Os instead of -O2 makes the error go
> away, so this is pretty much a compiler problem.
> I will check now if the error is still existent in the current developer
> version of gcc and then maybe contact the gcc team.
> 
> Meanwhile I'm really sorry for the noise and annoyance.

No problem, things go wrong for everyone.

> Thanks
> Mirco

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

