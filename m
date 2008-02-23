Return-Path: <linux-kernel-owner+w=401wt.eu-S936263AbYBWLii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936263AbYBWLii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 06:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932787AbYBWLiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 06:38:01 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:25256 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765521AbYBWLh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 06:37:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LvIZImsOPcp5CPJ2G30fIuG1c73/Ko20ThzUkxqrpivFxJp6DDGW9FxnDC3SjQ67dHCKmWSBo1dLl/FvIlUJuID/jRnqzn5qLigmoE/sdjX/MRspvwLL1nHq7MDaHzfpFTCYu5Q4cw7Dc/brTovrXZzqIWtSlpMD4HO7eyMTp6o=
Message-ID: <84144f020802230337s35c72b50wf8b892777bff42a2@mail.gmail.com>
Date: Sat, 23 Feb 2008 13:37:58 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Michael Buesch" <mb@bu3sch.de>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <f19298770802230332s286b8ac4ldbd64b6996cba308@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <200802221513.58608.mb@bu3sch.de>
	 <47BF101F.30301@protei.ru> <200802221848.37902.mb@bu3sch.de>
	 <20080223110751.GN23833@elte.hu>
	 <84144f020802230318hec5fe97h84c797a56b0dd5db@mail.gmail.com>
	 <20080223112436.GA31304@elte.hu>
	 <f19298770802230332s286b8ac4ldbd64b6996cba308@mail.gmail.com>
X-Google-Sender-Auth: 8ecaa605c2e502da
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 1:32 PM, Alexey Zaytsev
<alexey.zaytsev@gmail.com> wrote:
>  The problem is not with enabling both b43 and bcm43xx (will, whis won't work
>  anyway, and there is no chance fixing it). The problem is with enabling the
>  bcm43xx wifi driver and the b44 Ethernet driver. The ethernet driver then
>  wrongly autosolects some config options that prevent the bcm43xx
>  driver from loading, so I'm left with either no wifi or no ethenet.

So does reverting commit 753f492093da7a40141bfe083073400f518f4c68
("[B44]: port to native ssb support") fix the regression?
