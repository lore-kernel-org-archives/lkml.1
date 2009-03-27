Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbZC0XQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbZC0XQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZC0XQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:16:40 -0400
Received: from mail.fieldses.org ([141.211.133.115]:35050 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbZC0XQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:16:40 -0400
Date: Fri, 27 Mar 2009 19:16:34 -0400
To: ideawu <ideawu@163.com>
Cc: "nfsv4@linux-nfs.org" <nfsv4@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]sunrpc/svc.c: Remove unused line 'rqstp->rq_server =
	serv;' in svc_process
Message-ID: <20090327231634.GE18222@fieldses.org>
References: <200903261255292962249@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903261255292962249@163.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 12:55:29PM +0800, ideawu wrote:
> There is no need to set rqstp->rq_server to serv, while serv is initialized as rqstp->rq_server at previous line. And between these two lines, there is no change to rqstp->rq_server.

Thanks!  Applied.

> 
> Signed-off-by: ideawu <ideawu@163.com>
> --------
> 
> --- net/sunrpc/svc.c	2009-03-24 07:12:14.000000000 +0800
> +++ net/sunrpc/svc.mod.c	2009-03-26 09:39:15.187500000 +0800

(But next time please make sure the patch applies with 'patch -p1').

--b.

> @@ -1093,7 +1093,6 @@ svc_process(struct svc_rqst *rqstp)
>  	procp = versp->vs_proc + proc;
>  	if (proc >= versp->vs_nproc || !procp->pc_func)
>  		goto err_bad_proc;
> -	rqstp->rq_server   = serv;
>  	rqstp->rq_procinfo = procp;
> 
> 
> 
