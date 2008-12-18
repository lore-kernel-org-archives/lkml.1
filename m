Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753680AbYLRAey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbYLRAey (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 19:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYLRAel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 19:34:41 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:59950 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbYLRAek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 19:34:40 -0500
Date: Wed, 17 Dec 2008 16:34:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nick Andrew <nick@nick-andrew.net>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix incorrect use of loose in i2o_block.c
Message-Id: <20081217163429.225c5706.randy.dunlap@oracle.com>
In-Reply-To: <20081205030801.32014.92677.stgit@marcab.local.tull.net>
References: <20081205030801.32014.92677.stgit@marcab.local.tull.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.49499A9A.001F:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Dec 2008 14:08:01 +1100 Nick Andrew wrote:

> Fix incorrect use of loose in i2o_block.c
> 
> It should be 'lose', not 'loose'.
> 
> Signed-off-by: Nick Andrew <nick@nick-andrew.net>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com> # sorry about the delayed reply


> ---
> 
>  drivers/message/i2o/i2o_block.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
> index 84bdc2e..a443e13 100644
> --- a/drivers/message/i2o/i2o_block.c
> +++ b/drivers/message/i2o/i2o_block.c
> @@ -354,7 +354,7 @@ static inline void i2o_block_sglist_free(struct i2o_block_request *ireq)
>   *	@req: the request to prepare
>   *
>   *	Allocate the necessary i2o_block_request struct and connect it to
> - *	the request. This is needed that we not loose the SG list later on.
> + *	the request. This is needed that we not lose the SG list later on.
>   *
>   *	Returns BLKPREP_OK on success or BLKPREP_DEFER on failure.
>   */


---
~Randy
