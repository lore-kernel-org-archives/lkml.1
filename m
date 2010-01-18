Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748Ab0ARM5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab0ARM5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525Ab0ARM5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:57:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:54858 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab0ARM5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:57:42 -0500
Message-ID: <4B545AC5.5080306@suse.cz>
Date: Mon, 18 Jan 2010 13:57:41 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: Kconfig with multiple sources  of integer value
References: <20100111083002.GA24987@trinity.fluff.org>
In-Reply-To: <20100111083002.GA24987@trinity.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.1.2010 09:30, Ben Dooks wrote:
> It would be nice if I could say
> 
> config S3C24XX_GPIO_EXTRA
> 
> and then
> 
> config MACH_OSIRIS
>        ...
>        set_min S3C24XX_GPIO_EXTRA 128
> 
> or something similar.

Or maybe extend 'select' to accept
select FOO=<value>
and allow select for integer options too (in which case, the =<value>
would be mandatory). Then it would look like

config MACH_OSIRIS
       ...
       select S3C24XX_GPIO_EXTRA=128

What do you think?

Michal
