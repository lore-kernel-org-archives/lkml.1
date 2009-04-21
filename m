Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbZDURYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbZDURYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbZDURYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:24:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41382 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665AbZDURYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:24:24 -0400
Message-ID: <49EE00F9.6090000@zytor.com>
Date: Tue, 21 Apr 2009 10:23:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Matti Aarnio <matti.aarnio@zmailer.org>, Jesper Juhl <jj@chaosbits.net>,
       Prakash Punnoor <prakash@punnoor.de>, Michael Tokarev <mjt@tls.msk.ru>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
Subject: Re: Proposal: make RAID6 code optional
References: <200904180946.27722.prakash@punnoor.de> <49E98AD2.8060601@msgid.tls.msk.ru> <200904181117.03418.prakash@punnoor.de> <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net> <20090418145850.GD28512@mea-ext.zmailer.org> <49EDD11E.2030309@tmr.com>
In-Reply-To: <49EDD11E.2030309@tmr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> It would seem that that space could be allocated and populated when
> raid6 was first used, as part of the initialization. I haven't looked at
> that code since it was new, so I might be optimistic about doing it that
> way.

We could use vmalloc() and generate the tables at initialization time.
However, having a separate module which exports the raid6 declaration
and uses the raid5 module as a subroutine library seems easier.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

