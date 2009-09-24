Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbZIXQqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbZIXQqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbZIXQqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:46:08 -0400
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:40244 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752866AbZIXQqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:46:07 -0400
Message-ID: <4ABBA24E.7090709@panasas.com>
Date: Thu, 24 Sep 2009 19:46:06 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ricardo Labiaga <Ricardo.Labiaga@netapp.com>,
       Andy Adamson <andros@netapp.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       David Miller <davem@davemloft.net>, linux-nfs@vger.kernel.org,
       netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: fix htmldocs sunrpc, clnt.c
References: <1253794781.5860.29.camel@ht.satnam> <4ABB9C17.3020307@oracle.com>
In-Reply-To: <4ABB9C17.3020307@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Sep 2009 16:46:10.0562 (UTC) FILETIME=[85317620:01CA3D36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep. 24, 2009, 19:19 +0300, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Jaswinder Singh Rajput wrote:
>>   DOCPROC Documentation/DocBook/networking.xml
>>   Warning(net/sunrpc/clnt.c:647): No description found for parameter 'req'
>>   Warning(net/sunrpc/clnt.c:647): No description found for parameter 'tk_ops'
>>   Warning(net/sunrpc/clnt.c:647): Excess function parameter 'ops' description in 'rpc_run_bc_task'
>>
>> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> 
> Ack.  Already sent, but possibly lost.

Ack.  thanks!

> 
>> Cc: Ricardo Labiaga <Ricardo.Labiaga@netapp.com>
>> Cc: Benny Halevy <bhalevy@panasas.com>
>> Cc: Andy Adamson <andros@netapp.com>
>> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
>> Cc: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc: David Miller <davem@davemloft.net>
>> ---
>>  net/sunrpc/clnt.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
>> index a417d5a..38829e2 100644
>> --- a/net/sunrpc/clnt.c
>> +++ b/net/sunrpc/clnt.c
>> @@ -640,10 +640,11 @@ EXPORT_SYMBOL_GPL(rpc_call_async);
>>  /**
>>   * rpc_run_bc_task - Allocate a new RPC task for backchannel use, then run
>>   * rpc_execute against it
>> - * @ops: RPC call ops
>> + * @req: RPC request
>> + * @tk_ops: RPC call ops
>>   */
>>  struct rpc_task *rpc_run_bc_task(struct rpc_rqst *req,
>> -					const struct rpc_call_ops *tk_ops)
>> +				const struct rpc_call_ops *tk_ops)
>>  {
>>  	struct rpc_task *task;
>>  	struct xdr_buf *xbufp = &req->rq_snd_buf;
> 
