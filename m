Return-Path: <linux-kernel-owner+w=401wt.eu-S1762541AbZE0Mks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762541AbZE0Mks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbZE0Mkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:40:40 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43104 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbZE0Mkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:40:40 -0400
Date: Wed, 27 May 2009 20:17:18 +0800
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip] Documentation/accounting/getdelays.c intialize
	the variable before using it
Message-ID: <20090527121718.GD30062@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1242796484.3260.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1242796484.3260.12.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jaswinder Singh Rajput <jaswinder@kernel.org> [2009-05-20 10:44:44]:

> 
> May be in some cases cmd_type will be used uninitialized.
> 
> Also fixes compilation warning:
> 
>    CC [M]  Documentation/DocBook/procfs_example.o
>   Documentation/accounting/getdelays.c: In function ???main???:
>   Documentation/accounting/getdelays.c:249: warning: ???cmd_type??? may be used uninitialized in this function
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  Documentation/accounting/getdelays.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
> index 7ea2311..36aae3b 100644
> --- a/Documentation/accounting/getdelays.c
> +++ b/Documentation/accounting/getdelays.c
> @@ -246,7 +246,7 @@ void print_ioacct(struct taskstats *t)
> 
>  int main(int argc, char *argv[])
>  {
> -	int c, rc, rep_len, aggr_len, len2, cmd_type;
> +	int c, rc, rep_len, aggr_len, len2, cmd_type = TASKSTATS_CMD_ATTR_UNSPEC;

Thanks. The fix seems correct


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

I am away traveling with almost no time to check emails, hence I've
been slow responding. Thanks for being patient. 

-- 
	Balbir
