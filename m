Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbZBPNJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbZBPNJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 08:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbZBPNJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 08:09:38 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56125 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210AbZBPNJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:09:37 -0500
Message-ID: <49996588.2040501@s5r6.in-berlin.de>
Date: Mon, 16 Feb 2009 14:09:28 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Manish Katiyar <mkatiyar@gmail.com>
CC: mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Remove errors caught by checkpatch.pl in kernel/utsname_sysctl.c
References: <ea11fea30902151039n447cc111medb9721a95af81a8@mail.gmail.com>
In-Reply-To: <ea11fea30902151039n447cc111medb9721a95af81a8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manish Katiyar wrote:
> --- a/kernel/utsname_sysctl.c
> +++ b/kernel/utsname_sysctl.c
> @@ -49,7 +49,7 @@ static int proc_do_uts_string(ctl_table *table, int
> write, struct file *filp,
>  	int r;
>  	memcpy(&uts_table, table, sizeof(uts_table));
>  	uts_table.data = get_uts(table, write);
> -	r = proc_dostring(&uts_table,write,filp,buffer,lenp, ppos);
> +	r = proc_dostring(&uts_table, write, filp, buffer, lenp, ppos);
>  	put_uts(table, write, uts_table.data);
>  	return r;
>  }
> @@ -142,4 +142,4 @@ static int __init utsname_sysctl_init(void)
>  	return 0;
>  }
> 
> -__initcall(utsname_sysctl_init);
> +device_initcall(utsname_sysctl_init);

The changelog should note that this is a whitespace fix + initcall
annotation change.

That checkpatch was somehow involved in the creation of this patch is
entirely uninteresting for the changelog.
-- 
Stefan Richter
-=====-==--= --=- =----
http://arcgraph.de/sr/
