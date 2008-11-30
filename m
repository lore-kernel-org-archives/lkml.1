Return-Path: <linux-kernel-owner+w=401wt.eu-S1751713AbYK3GoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbYK3GoP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 01:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750792AbYK3Gn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 01:43:57 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:45113 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYK3Gn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 01:43:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wAK/cUBXca53eCyINggZ2GBxbTfUwkLfNHoVaQa7B/vPsG0AeVxtok0f7np73pdGP8
         3uBEsz04QheGQquGMDvVHv3dfa19MWUwYtRMqB5x1/5qLIhrORciMDp13wJH0qCKnCVi
         X6KniScGXczlLg5gxxtTotEz39uAgdQJzE4u0=
Message-ID: <9b2db90b0811292243o797c12d9iaf4d313af5f43698@mail.gmail.com>
Date: Sun, 30 Nov 2008 08:43:54 +0200
From: "Nir Tzachar" <nir.tzachar@gmail.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: [PATCH] nconfig V3
Cc: linux-kernel@vger.kernel.org, bzolnier@gmail.com, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, ariveira@gmail.com, rdunlap@xenotime.net,
       7eggert@gmx.de, kosaki.motohiro@jp.fujitsu.com, sam@ravnborg.org
In-Reply-To: <20081129230234.GA23504@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227994959-17627-2-git-send-email-nir.tzachar@gmail.com>
	 <20081129230234.GA23504@Pilar.aei.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Sun, Nov 30, 2008 at 1:02 AM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
> On Sat 29.Nov'08 at 23:42:39 +0200, Nir Tzachar wrote:
>> [...]
>> +static ITEM *btns_items[BTN_MAX];

Thanks. This should be btns_items[BTN_MAX+1];

> [...]
>
>> +     btns_items[BTN_MAX] = NULL;
>
> gcc warns about this here
>
> scripts/kconfig/nconf.c:1311: warning: array subscript is above array bounds
>

Cheers.
