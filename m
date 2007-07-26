Return-Path: <linux-kernel-owner+w=401wt.eu-S1763994AbXGZXQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763994AbXGZXQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbXGZXQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:16:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:14265 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbXGZXQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:16:29 -0400
Message-ID: <5640c7e00707261616x8eb332fg2406b72d2e1f1f12@mail.gmail.com>
Date: Fri, 27 Jul 2007 11:16:28 +1200
From: "Ian McDonald" <ian.mcdonald@jandi.co.nz>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH][dccp] Fix memory leak and clean up style - dccp_feat_empty_confirm()
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrea Bittau" <a.bittau@cs.ucl.ac.uk>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       dccp@vger.kernel.org
In-Reply-To: <200707270039.37860.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707270039.37860.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/27/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
>
> Greetings,
>
> There's a memory leak in net/dccp/feat.c::dccp_feat_empty_confirm().
> If we hit the 'default:' case of the 'switch' statement, then we
> return without freeing 'opt', thus leaking 'struct dccp_opt_pend'
> bytes.
> The leak is fixed easily enough by adding a kfree(opt); before the
> return statement.
> The patch also changes the layout of the 'switch' to be more in line
> with CodingStyle.
>
> Patch has been compile tested.
>
> Please consider merging.
>
>
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Signed-off-by: Ian McDonald <ian.mcdonald@jandi.co.nz>
-- 
Web1: http://wand.net.nz/~iam4/
Web2: http://www.jandi.co.nz
Blog: http://iansblog.jandi.co.nz
