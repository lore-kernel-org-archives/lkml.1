Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbZABQLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbZABQLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbZABQKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:10:55 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:26657 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131AbZABQKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:10:55 -0500
Message-ID: <495E3C7B.50505@oracle.com>
Date: Fri, 02 Jan 2009 08:10:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>,
       Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-mmotm1230 drivers/input/input.c warning msg
References: <27989.1230891358@turing-police.cc.vt.edu>
In-Reply-To: <27989.1230891358@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.495E3C7E.01B9:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> patch input-allow-certain-ev_abs-events-to-bypass-all-filtering.patch
> caused a new warning to be added to the compile:
> 
>   CC      drivers/input/input.o
> drivers/input/input.c:1661: warning: function declaration isnâ€™t a prototype
> 
> Fix up the declaration so the compiler knows what the prototype is.
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

This is the third patch like this that's been posted, so I'll ack this one.  ;)

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> --- linux-2.6.28-mmotm1230/drivers/input/input.c.dist	2009-01-01 17:23:02.000000000 -0500
> +++ linux-2.6.28-mmotm1230/drivers/input/input.c	2009-01-02 05:09:12.000000000 -0500
> @@ -1657,7 +1657,7 @@ static const struct file_operations inpu
>  	.open = input_open_file,
>  };
>  
> -static void __init input_init_abs_bypass()
> +static void __init input_init_abs_bypass(void)
>  {
>  	const unsigned int *p;
>  	for (p = input_abs_bypass_init_data; *p; p++)
> 


-- 
~Randy
