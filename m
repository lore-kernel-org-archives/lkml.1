Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbZBHRjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbZBHRjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 12:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZBHRjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 12:39:43 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:36178 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZBHRjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 12:39:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kl4P+VUPKpNFDSOrnLzP51CEsc34w1EnayJvmlnsjY72TVA1uv/mW6rmTEylsvkLFM
         g6ZsrmBNDPUCtGMmgrJHbl0mPJbVgcrwnW5PAMnlgJK4ZAAMFA5rY06dk3CI7dI33uR/
         CFpo5PAMzIt4x2FMZqPnhOqWknValzzBGbMCc=
Message-ID: <498F1979.1030104@gmail.com>
Date: Sun, 08 Feb 2009 18:42:17 +0100
From: Mariusz Ceier <mceier@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090101)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: David Brownell <david-b@pacbell.net>,
       spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] spi: limit reaches -1, tested 0
References: <498EE9C0.3010601@gmail.com> <200902080755.26241.david-b@pacbell.net> <200902080828.49036.david-b@pacbell.net> <498F0D64.4040909@gmail.com>
In-Reply-To: <498F0D64.4040909@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin writes in first post:
> -			while ((read(drv_data) == 0) && limit--);
> +			while ((read(drv_data) == 0) && --limit);

Roel Kluin writes in last post:
> -			while ((read(drv_data) == 0) && limit--);
> +			while ((read(drv_data) == 0) && limit--)
> +				cpu_relax();

so should there be postfix or prefix decrement ? :)

Mariusz Ceier


