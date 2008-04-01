Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYDAHnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYDAHnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 03:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755696AbYDAHnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 03:43:08 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:60986 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbYDAHnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 03:43:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hTR68FPtpNtnt99f/UyFlApzAEakM1Oc5Fdkf2rBBA3Hmi26fuEo6JTxaKCY4Il343ho+nf/DRCXL6zBIOwliDX7xoP5lAey041eOrf9Z6o1esXZkioQuNVb0tK8nkaGrGstAvUD4zzwQrJYzidEe2zTviqrjS+oCHhUUltu194=
Message-ID: <84144f020804010043v100ea81an42006d62659e91fa@mail.gmail.com>
Date: Tue, 1 Apr 2008 10:43:03 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Artem Bityutskiy" <dedekind@yandex.ru>
Subject: Re: [RFC PATCH 25/26] UBIFS: add debugging stuff
Cc: "Artem Bityutskiy" <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Adrian Hunter" <ext-adrian.hunter@nokia.com>
In-Reply-To: <47F1D44A.8010908@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
	 <1206629746-4298-26-git-send-email-Artem.Bityutskiy@nokia.com>
	 <84144f020803311400s1f34420dx153d197f4752c65e@mail.gmail.com>
	 <47F1D44A.8010908@yandex.ru>
X-Google-Sender-Auth: 946fcc31895bc3c8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On Tue, Apr 1, 2008 at 9:20 AM, Artem Bityutskiy <dedekind@yandex.ru> wrote:
>  Yeah, we will remove this later, keep it for now because it is very
>  convenient. I guess you refer the /proc/slab_allocations feature.
>  We found it less appropriate because it needs additional scripts to
>  be run to detect leaks, while this simple just hack makes UBIFS print
>  a message if there is a leak, which is just easier for us.

Why not fix it then to fit your needs? You do need leak detection
after you're in the mainline too, don't you?

On Tue, Apr 1, 2008 at 9:20 AM, Artem Bityutskiy <dedekind@yandex.ru> wrote:
>  That was introduced to test the UBIFS shrinker, and to make sure
>  there are no races and everything works fine. Yes, will be removed
>  later.

It sounds useful and necessary for developing in the mainline as well
so you might want to reconsider making it a standalone module in mm/.

                       Pekka
