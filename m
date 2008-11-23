Return-Path: <linux-kernel-owner+w=401wt.eu-S1757891AbYKWJ2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbYKWJ2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 04:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYKWJ2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 04:28:41 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36940 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872AbYKWJ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 04:28:40 -0500
Date: Sun, 23 Nov 2008 10:28:36 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBIFS: endian handling fixes and annotations
Message-ID: <20081123092836.GA24756@Chamillionaire.breakpoint.cc>
References: <1227287970-14684-1-git-send-email-dedekind@infradead.org> <1227287970-14684-3-git-send-email-dedekind@infradead.org> <20081122192747.GB21433@Chamillionaire.breakpoint.cc> <1227410489.6117.1.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1227410489.6117.1.camel@brick>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Harvey Harrison | 2008-11-22 19:21:29 [-0800]:

>Nope, no difference, cpu_to_le32 does constant-detection these days and
>so there ends up being no difference.

Indeed. __builtin_constant_p() does the trick. So I guess we could get
rid of __constant_cpu_to_XX32() and its

| grep -RE __constant_cpu_to_[bl]e32 . | wc -l
| 413

users.

>
>Harvey
>

Sebastian
