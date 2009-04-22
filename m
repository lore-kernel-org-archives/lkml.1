Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZDVJBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZDVJBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 05:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZDVJBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 05:01:23 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:59577 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578AbZDVJBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 05:01:21 -0400
From: Goswin von Brederlow <goswin-v-b@web.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Matti Aarnio <matti.aarnio@zmailer.org>,
       Jesper Juhl <jj@chaosbits.net>, Prakash Punnoor <prakash@punnoor.de>,
       Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, neilb@suse.de
Subject: Re: Proposal: make RAID6 code optional
References: <200904180946.27722.prakash@punnoor.de>
	<49E98AD2.8060601@msgid.tls.msk.ru>
	<200904181117.03418.prakash@punnoor.de>
	<alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net>
	<20090418145850.GD28512@mea-ext.zmailer.org>
	<49EDD11E.2030309@tmr.com> <49EE00F9.6090000@zytor.com>
Date: Wed, 22 Apr 2009 11:01:16 +0200
In-Reply-To: <49EE00F9.6090000@zytor.com> (H. Peter Anvin's message of "Tue,
	21 Apr 2009 10:23:05 -0700")
Message-ID: <87ljptm59f.fsf@frosties.localdomain>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1/V1CNNRQo66COO/9ERDLJnz6F2uDm6ECIIc/8i
	UcqHXXW+pLKlCLNyndXlW+3SRytm3wR3SpHLxp3hfq8TedWdWY
	wzoSzbp0U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Bill Davidsen wrote:
>> It would seem that that space could be allocated and populated when
>> raid6 was first used, as part of the initialization. I haven't looked at
>> that code since it was new, so I might be optimistic about doing it that
>> way.
>
> We could use vmalloc() and generate the tables at initialization time.
> However, having a separate module which exports the raid6 declaration
> and uses the raid5 module as a subroutine library seems easier.
>
> 	-hpa

Combine the two.

The raid6 module initializes the tables for raid6 and uses the raid5
module as subroutine library.

MfG
        Goswin
