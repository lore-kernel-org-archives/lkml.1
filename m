Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYLVK21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYLVK21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 05:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYLVK2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 05:28:17 -0500
Received: from h155.mvista.com ([63.81.120.155]:45935 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751483AbYLVK2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 05:28:16 -0500
Message-ID: <494F6BB9.5020406@ru.mvista.com>
Date: Mon, 22 Dec 2008 13:28:09 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/11] drivers/ide: Move a dereference below a NULL test
References: <Pine.LNX.4.64.0812161611280.20444@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0812161611280.20444@pc-004.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Julia Lawall wrote:

> In each case, if the NULL test is necessary, then the dereference should be
> moved below the NULL test.
>
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
>
> // <smpl>
> @@
> type T;
> expression E;
> identifier i,fld;
> statement S;
> @@
>
> - T i = E->fld;
> + T i;
>   ... when != E
>       when != i
>   if (E == NULL) S
> + i = E->fld;
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


