Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbYKPMAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbYKPMAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 07:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYKPMAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 07:00:06 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56401 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbYKPMAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 07:00:04 -0500
Message-ID: <49200B3C.7020203@gentoo.org>
Date: Sun, 16 Nov 2008 12:59:56 +0100
From: =?UTF-8?B?UmHDumwgUG9yY2Vs?= <armin76@gentoo.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-alpha@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       klausman@gentoo.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, rth@twiddle.net
Subject: Re: [ALPHA] 2.6.28-rc fails to compile
References: <49083361.5060907@gentoo.org> <20081029100356.GA28224@cs181140183.pp.htv.fi> <20081029062741.7400e330@infradead.org> <20081029134553.GA9108@cs181140183.pp.htv.fi> <20081029065935.7a5930f9@infradead.org> <20081029141909.GC9108@cs181140183.pp.htv.fi>
In-Reply-To: <20081029141909.GC9108@cs181140183.pp.htv.fi>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Oct 29, 2008 at 06:59:35AM -0700, Arjan van de Ven wrote:
>> On Wed, 29 Oct 2008 15:45:53 +0200
>> Adrian Bunk <bunk@kernel.org> wrote:
>>
>>> On Wed, Oct 29, 2008 at 06:27:41AM -0700, Arjan van de Ven wrote:
>>>> Andrew has a patch for this in his tree for a while... I was
>>>> assuming he'd do a patchdump to Linus late in -rc1 but it seems not
>>>> to have happened..
>>> The basic problem for the Alpha build errors are circular #include's 
>>> (that are anyway a pretty bad thing), and I'm currently attacking
>>> that problem (it seems to be surprisingly easy).
>>>
>>> That's IMHO better than the patch in -mm that uninlines 
>>> pci_ioremap_bar().
>> and in my opinion the uninline is nicer ;)
>> Because that means we can add more checks to it over time without
>> bloating the kernel.
> 
> My usage of the word "better" was wrong.
> 
> For fixing the compile error I do consider the patch I'm currently 
> testing as better, since this could otherwise beat us again in the 
> future.
> 
> But the patches are completely orthogonal, and there's no reason against 
> including both.
> 
> cu
> Adrian
> 

Any news? Something i could test?
rc5 still fails, just FYI :)
