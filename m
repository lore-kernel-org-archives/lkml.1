Return-Path: <linux-kernel-owner+w=401wt.eu-S1765139AbYEFUT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765139AbYEFUT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbYEFUTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:19:48 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:29573 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbYEFUTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:19:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=M5uFWC7ArP3wOU5F3FsSXGsWza0Ye3BjdoX04SOcdWNBbxoyJqaSUIwrkO4zPGo4HtsIDvgOwLI/tQidsaaUuSTSGkTAVIVzBro9ZwCO+RJnvLpK03pIIP4mEp0S3lTr6/v1ghIzxiWmd/9WsfdlXSHLnwBPAxpAV+6lT5P9yps=
Message-ID: <2f11576a0805061319w581f69d4ye593416db6a9e80a@mail.gmail.com>
Date: Wed, 7 May 2008 05:19:45 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] mm/cgroup.c add error check
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Paul Menage" <menage@google.com>, "Li Zefan" <lizf@cn.fujitsu.com>
In-Reply-To: <4820A431.3000600@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080506195216.4A6D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <87wsm7bo1n.fsf@basil.nowhere.org>
	 <2f11576a0805060602gf4cf0f9t85391939146efccf@mail.gmail.com>
	 <4820A431.3000600@firstfloor.org>
X-Google-Sender-Auth: 4836f782e94d78fb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > but if GFP_KERNEL is used, We still need error check, IMHO.
>
>  Yes, but no retry (or if you're sure you cannot fail use __GFP_NOFAIL
>  too, but that is nasty because it has some risk of deadlock under severe
>  oom conditions)

in general coding style, you are right.

but not down-to-earth idea in that case.
call_usermodehelper() is just wrapper of fork-exec.

I don't hope change largely exec() code patch.
