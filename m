Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797Ab0AWTng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab0AWTng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 14:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027Ab0AWTnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 14:43:35 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:63999 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab0AWTne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 14:43:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QMfHlTrEj6GKYyZ2CNuT4Odr3Ehj47nNwrHpD2F6QXY0CdfbiwCP1VFPysMHTD8xZP
         qLf9YHZ7EqJgqdDYOibjd6f5WiFfarGPlP5YnTXfBHD5SE7XhTvNSZMmBZN304rJBb8A
         YPjsMPl3k7SwYL5Dl+cXV4JXH/SAtq2CdPXq4=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1001161657170.28745@ask.diku.dk>
References: <Pine.LNX.4.64.1001161657170.28745@ask.diku.dk>
Date: Sat, 23 Jan 2010 21:43:32 +0200
Message-ID: <1ba2fa241001231143l595f2861kda19831ffa1da2cd@mail.gmail.com>
Subject: Re: [PATCH 2/9] drivers/misc: Eliminate useless code
From: Tomas Winkler <tomasw@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 16, 2010 at 5:57 PM, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> The variable priv is initialized twice to the same (side effect-free)
> expression.  Drop one initialization.
>
> A simplified version of the semantic match that finds this problem is:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @forall@
> idexpression *x;
> identifier f!=ERR_PTR;
> @@
>
> x = f(...)
> ... when != x
> (
> x = f(...,<+...x...+>,...)
> |
> * x = f(...)
> )
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by Tomas.Winker <tomas.winkler@intel.com>


I appreciate if you CC me next time.

Thanks
Tomas
