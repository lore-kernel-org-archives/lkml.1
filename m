Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbZDWBg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbZDWBg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 21:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZDWBgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 21:36:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38010 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZDWBgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 21:36:16 -0400
Message-ID: <49EFC5DD.9090201@zytor.com>
Date: Wed, 22 Apr 2009 18:35:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andre Noll <maan@systemlinux.org>
CC: Bill Davidsen <davidsen@tmr.com>, Matti Aarnio <matti.aarnio@zmailer.org>,
       Jesper Juhl <jj@chaosbits.net>, Prakash Punnoor <prakash@punnoor.de>,
       Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, neilb@suse.de
Subject: Re: Proposal: make RAID6 code optional
References: <200904180946.27722.prakash@punnoor.de> <49E98AD2.8060601@msgid.tls.msk.ru> <200904181117.03418.prakash@punnoor.de> <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net> <20090418145850.GD28512@mea-ext.zmailer.org> <49EDD11E.2030309@tmr.com> <49EE00F9.6090000@zytor.com> <20090422180051.GD13280@skl-net.de> <49EF6457.90505@zytor.com> <20090422185703.GF13280@skl-net.de>
In-Reply-To: <20090422185703.GF13280@skl-net.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andre Noll wrote:
> On 11:39, H. Peter Anvin wrote:
>> Yes, I believe it would be easier than having dynamically allocated 
>> arrays.  Dynamically generated arrays using static memory allocations 
>> (bss) is one thing, but that would only reduce size of the module on 
>> disk, which I don't think anyone considers a problem.
> 
> We would save 64K of RAM in the raid5-only case if we'd defer the
> allocation of the multiplication table until the first raid6 array
> is about to be started.

Yes, and we'd have to access it through a pointer for the rest of eternity.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

