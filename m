Return-Path: <linux-kernel-owner+w=401wt.eu-S1765927AbYDQKgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765927AbYDQKgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758817AbYDQKgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:36:45 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46431 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbYDQKgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:36:44 -0400
Date: Thu, 17 Apr 2008 13:36:35 +0300
From: Adrian Bunk <bunk@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       akpm@osdl.org
Subject: Re: [RFC patch 15/27] Immediate Values - Documentation
Message-ID: <20080417103635.GG1677@cs181133002.pp.htv.fi>
References: <20080416213426.298498397@polymtl.ca> <20080416213552.942797527@polymtl.ca> <20080417184930.A8CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080417184930.A8CD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 06:52:54PM +0900, KOSAKI Motohiro wrote:
> > +Memory read:
> > +644.09ツア11.39 - 88.16ツア1.35 = 555.93ツア11.46 cycles
> > +
> > +Getppid without memory pressure:
> > +1462.09ツア18.87 - 150.92ツア1.01 = 1311.17ツア18.90 cycles
> > +
> > +Getppid with memory pressure:
> > +17113.33ツア1655.92 - 578.22ツア269.51 = 16535.11ツア1677.71 cycles
> > +
> > +Therefore, if we add 2 markers not based on immediate values to the getppid
> > +code, which would add 2 memory reads, we would add
> > +2 * 555.93ツア12.74 = 1111.86ツア25.48 cycles
> 
> sorry..
> 
> non ascii character is harmful for some language region user.
> Couldn't you write ascii only?

The kernel is UTF-8, and this shouldn't be a problem.

The problem seems to be that Mathieu's emails don't contain a header 
indicating the charset.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

