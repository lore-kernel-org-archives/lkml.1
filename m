Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZBPPed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZBPPed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbZBPPeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:34:24 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56543 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZBPPeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:34:24 -0500
Message-ID: <49998788.80606@s5r6.in-berlin.de>
Date: Mon, 16 Feb 2009 16:34:32 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Manish Katiyar <mkatiyar@gmail.com>
CC: mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Remove errors caught by checkpatch.pl in 	kernel/utsname_sysctl.c
References: <ea11fea30902151039n447cc111medb9721a95af81a8@mail.gmail.com>	 <49996588.2040501@s5r6.in-berlin.de> <ea11fea30902160659q58578152gea3f4da3821c8e0c@mail.gmail.com>
In-Reply-To: <ea11fea30902160659q58578152gea3f4da3821c8e0c@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manish Katiyar wrote:
> On Mon, Feb 16, 2009 at 6:39 PM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
>> The changelog should note that this is a whitespace fix + initcall
>> annotation change.

Sorry, I didn't get the point of __initcall/device_initcall.  It's not
an annotation; it defines a call sequence level.

> Replace deprecated __initcall with equivalent device_initcall. Also
> fix whitespaces.
...
> --- a/kernel/utsname_sysctl.c
> +++ b/kernel/utsname_sysctl.c
...
> @@ -142,4 +142,4 @@ static int __init utsname_sysctl_init(void)
>  	return 0;
>  }
> 
> -__initcall(utsname_sysctl_init);
> +device_initcall(utsname_sysctl_init);

It is equivalent, but is it also the most appropriate one?
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
