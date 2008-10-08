Return-Path: <linux-kernel-owner+w=401wt.eu-S1757134AbYJHW05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbYJHW05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 18:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbYJHW0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 18:26:47 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3199 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbYJHW0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 18:26:47 -0400
Date: Wed, 8 Oct 2008 15:22:20 -0700 (PDT)
From: Joe Perches <joe@perches.com>
To: trem <tremyfr@yahoo.fr>
cc: <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [patch] clean hex output of ftrace
In-Reply-To: <48ED2E5E.3040600@yahoo.fr>
Message-ID: <Pine.LNX.4.30.0810081515510.1836-100000@perches.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2008, trem wrote:
> Index: linux-2.6.26/kernel/trace/trace.c
> ===================================================================
> --- linux-2.6.26/kernel/trace/trace.c
> +++ linux-2.6.26/kernel/trace/trace.c   2008-10-08 22:30:29.000000000 +0200
> @@ -415,8 +415,8 @@
>  #endif
>                 byte = data[i];
>
> -               hex[j++] = hex2asc[byte & 0x0f];
>                 hex[j++] = hex2asc[byte >> 4];
> +               hex[j++] = hex2asc[byte & 0x0f];
>         }
>         hex[j++] = ' ';

I'm surprised Harvey Harrison hasn't changed it to pack_hex_byte
and removed the static.

