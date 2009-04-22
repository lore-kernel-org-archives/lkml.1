Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbZDVSba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbZDVSba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 14:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbZDVSbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 14:31:18 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:35997 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbZDVSbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 14:31:17 -0400
From: Goswin von Brederlow <goswin-v-b@web.de>
To: Andre Noll <maan@systemlinux.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Bill Davidsen <davidsen@tmr.com>,
       Matti Aarnio <matti.aarnio@zmailer.org>, Jesper Juhl <jj@chaosbits.net>,
       Prakash Punnoor <prakash@punnoor.de>, Michael Tokarev <mjt@tls.msk.ru>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
Subject: Re: Proposal: make RAID6 code optional
References: <200904180946.27722.prakash@punnoor.de>
	<49E98AD2.8060601@msgid.tls.msk.ru>
	<200904181117.03418.prakash@punnoor.de>
	<alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net>
	<20090418145850.GD28512@mea-ext.zmailer.org>
	<49EDD11E.2030309@tmr.com> <49EE00F9.6090000@zytor.com>
	<20090422180051.GD13280@skl-net.de>
Date: Wed, 22 Apr 2009 20:31:13 +0200
In-Reply-To: <20090422180051.GD13280@skl-net.de> (Andre Noll's message of
	"Wed, 22 Apr 2009 20:00:51 +0200")
Message-ID: <87vdowlevi.fsf@frosties.localdomain>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX19f+rLycQbQ2L9/On4EKLgATo6klhsk1y2ocbp1
	/m/M57gvJ/1TckpHxfxmbjk1e1TmW1kiquk21XnnumMMBsXZN7
	AaxbA8yxs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andre Noll <maan@systemlinux.org> writes:

> On 10:23, H. Peter Anvin wrote:
>
>> We could use vmalloc() and generate the tables at initialization time.
>> However, having a separate module which exports the raid6 declaration
>> and uses the raid5 module as a subroutine library seems easier.
>
> Really? Easier than keeping only two 256-byte arrays for exp() and
> log() and use these at runtime to populate the (dynamically allocated)
> 64K GF multiplication table? That seems to be really simple and would
> still shave off 64K of kernel memory for raid5-only users.
>
> Andre

Oh, you mean when the first raid6 device is started and not when the
module is loaded. That would work.

MfG
        Goswin
