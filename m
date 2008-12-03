Return-Path: <linux-kernel-owner+w=401wt.eu-S1751826AbYLCNok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbYLCNok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 08:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbYLCNoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 08:44:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41068 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbYLCNob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 08:44:31 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200812012326.50334.rusty@rustcorp.com.au>
References: <200812012326.50334.rusty@rustcorp.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Ralf Baechle <ralf@linux-mips.org>, Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 7/8] Call early_param earlier.
Date: Wed, 03 Dec 2008 13:44:10 +0000
Message-ID: <5294.1228311850@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

>  	parse_args("Core params", boot_command_line, __start___core_param,
>  		   __stop___core_param - __start___core_param,
>  		   unknown_core_ok, true);
> +	/* All fall through to do_early_param. */
> +	parse_args("early options", boot_command_line, NULL, 0, do_early_param,
> +		   true);

Why have two separate lists since they are processed contiguously?

David
