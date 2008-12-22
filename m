Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbYLVTif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbYLVTif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 14:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYLVTi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 14:38:27 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:59759 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbYLVTi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 14:38:26 -0500
Date: Mon, 22 Dec 2008 11:38:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-doc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/33] Documentation: Make static
Message-Id: <20081222113816.bf8be24b.randy.dunlap@oracle.com>
In-Reply-To: <493EA2F9.2010408@gmail.com>
References: <493EA286.7080500@gmail.com>
	<493EA2F9.2010408@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.494FECAB.0165:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Dec 2008 17:55:21 +0100 Roel Kluin wrote:

> Sparse asked whether these could be static.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

>  Documentation/DocBook/procfs_example.c |    2 +-
>  Documentation/connector/cn_test.c      |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/procfs_example.c b/Documentation/DocBook/procfs_example.c
> index 8c6396e..db06753 100644
> --- a/Documentation/DocBook/procfs_example.c
> +++ b/Documentation/DocBook/procfs_example.c
> @@ -54,7 +54,7 @@ static struct proc_dir_entry *example_dir, *foo_file,
>  	*bar_file, *jiffies_file, *symlink;
>  
>  
> -struct fb_data_t foo_data, bar_data;
> +static struct fb_data_t foo_data, bar_data;
>  
>  
>  static int proc_read_jiffies(char *page, char **start,
> diff --git a/Documentation/connector/cn_test.c b/Documentation/connector/cn_test.c
> index be7af14..b984b5b 100644
> --- a/Documentation/connector/cn_test.c
> +++ b/Documentation/connector/cn_test.c
> @@ -32,7 +32,7 @@ static char cn_test_name[] = "cn_test";
>  static struct sock *nls;
>  static struct timer_list cn_test_timer;
>  
> -void cn_test_callback(void *data)
> +static void cn_test_callback(void *data)
>  {
>  	struct cn_msg *msg = (struct cn_msg *)data;
>  


---
~Randy
