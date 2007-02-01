Return-Path: <linux-kernel-owner+w=401wt.eu-S932099AbXBAWwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbXBAWwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 17:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932564AbXBAWwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 17:52:32 -0500
Received: from ozlabs.org ([203.10.76.45]:44829 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099AbXBAWwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 17:52:31 -0500
From: Michael Neuling <mikey@neuling.org>
To: Carl Love <cel@us.ibm.com>
cc: cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CELL PPU Oprofile cleanup patch 
In-reply-to: <1170360615.5204.18.camel@dyn9047021078.beaverton.ibm.com> 
References: <1170360615.5204.18.camel@dyn9047021078.beaverton.ibm.com>
Comments: In-reply-to Carl Love <cel@us.ibm.com>
   message dated "Thu, 01 Feb 2007 12:10:15 -0800."
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 21.4.1
Date: Fri, 02 Feb 2007 09:52:28 +1100
Message-ID: <10720.1170370348@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carl,

> +#define NUM_TRACE_BUS_WORDS 4
> +#define NUM_INPUT_BUS_WORDS 2

<snip>

> -	for (i = 0; i < 4; i++)
> +	for (i = 0; i < NUM_INPUT_BUS_WORDS; i++)
>  		trace_bus[i] = 0xff;
>  
> -	for (i = 0; i < 2; i++)
> +	for (i = 0; i < NUM_INPUT_BUS_WORDS; i++)
>  		input_bus[i] = 0xff;

The first loop looks like a bug...   Shouldn't it be NUM_TRACE_BUS_WORDS?

Mikey
