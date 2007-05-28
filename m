Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbXE1KnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbXE1KnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750723AbXE1KnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:43:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:44602 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbXE1KnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:43:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=h6g5+92yK7vgUd/LpB7QU/M6Tu/escXWolBtnu3e34QI1fnz29m1PNLvTmAa30unaPnj7TyQVnqs5Sxms17nyLmuovuCaacAD4ZAv+whwapE75ha5ZFnN3djrYoSc2MKV546/1hf4ph7BJqthXCONICdPsocV+tCZjI1RU3c6j4=
Message-ID: <84144f020705280343q7e1646ar6961e7c0fa6b327f@mail.gmail.com>
Date: Mon, 28 May 2007 13:43:12 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: 2.6.22-rc2-mm1 - a different BUG: at mm/slab.c:777 __find_general_cachep()
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <13451.1180348036@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	 <13451.1180348036@turing-police.cc.vt.edu>
X-Google-Sender-Auth: 883901bbefbe3467
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> [4294667.472000] BUG: at mm/slab.c:777 __find_general_cachep()

[snip]

> Any suggestions before I go doing the bisect shuffle?

It's complaining about a kmalloc() with size zero. The warning is new
and harmless for now, so no need to bisect this (it will point you at
the mm/slab.c change by Christoph Lameter).
