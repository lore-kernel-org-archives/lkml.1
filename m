Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZIXQTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZIXQTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZIXQTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:19:43 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:25211 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbZIXQTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:19:42 -0400
Message-ID: <4ABB9C17.3020307@oracle.com>
Date: Thu, 24 Sep 2009 09:19:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ricardo Labiaga <Ricardo.Labiaga@netapp.com>,
       Benny Halevy <bhalevy@panasas.com>, Andy Adamson <andros@netapp.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       David Miller <davem@davemloft.net>, linux-nfs@vger.kernel.org,
       netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: fix htmldocs sunrpc, clnt.c
References: <1253794781.5860.29.camel@ht.satnam>
In-Reply-To: <1253794781.5860.29.camel@ht.satnam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4ABB9BDB.002E:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
>   DOCPROC Documentation/DocBook/networking.xml
>   Warning(net/sunrpc/clnt.c:647): No description found for parameter 'req'
>   Warning(net/sunrpc/clnt.c:647): No description found for parameter 'tk_ops'
>   Warning(net/sunrpc/clnt.c:647): Excess function parameter 'ops' description in 'rpc_run_bc_task'
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Ack.  Already sent, but possibly lost.

> Cc: Ricardo Labiaga <Ricardo.Labiaga@netapp.com>
> Cc: Benny Halevy <bhalevy@panasas.com>
> Cc: Andy Adamson <andros@netapp.com>
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: David Miller <davem@davemloft.net>
> ---
>  net/sunrpc/clnt.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
> index a417d5a..38829e2 100644
> --- a/net/sunrpc/clnt.c
> +++ b/net/sunrpc/clnt.c
> @@ -640,10 +640,11 @@ EXPORT_SYMBOL_GPL(rpc_call_async);
>  /**
>   * rpc_run_bc_task - Allocate a new RPC task for backchannel use, then run
>   * rpc_execute against it
> - * @ops: RPC call ops
> + * @req: RPC request
> + * @tk_ops: RPC call ops
>   */
>  struct rpc_task *rpc_run_bc_task(struct rpc_rqst *req,
> -					const struct rpc_call_ops *tk_ops)
> +				const struct rpc_call_ops *tk_ops)
>  {
>  	struct rpc_task *task;
>  	struct xdr_buf *xbufp = &req->rq_snd_buf;

