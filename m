Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbYGKL7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbYGKL7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYGKL66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:58:58 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:25808 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574AbYGKL65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:58:57 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgcFAKfndkhQyAvq/2dsb2JhbACBW64b
Date: Fri, 11 Jul 2008 13:58:55 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Corey Minyard <minyard@acm.org>
Cc: Mark Rustad <MRustad@gmail.com>, openipmi-developer@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [Openipmi-developer] [PATCH] IPMI: return correct value from ipmi_write
Message-ID: <20080711115855.GA517@infomag.infomag.iguana.be>
References: <4876628f.41O/uzQ5H7nSU2Vg%MRustad@gmail.com> <48766E2E.4060701@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48766E2E.4060701@acm.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> This patch is correct.
> 
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> 
> Mark Rustad wrote:
> >From: Mark Rustad <MRustad@gmail.com>
> >
> >This patch corrects the handling of write operations to the IPMI watchdog
> >to work as intended by returning the number of characters actually
> >processed. Without this patch, an "echo V >/dev/watchdog" enables the
> >watchdog if IPMI is providing the watchdog function.
> >
> >Signed-off-by: Mark Rustad <MRustad@gmail.com>

I'll add this to he linux-2.6-watchdog tree this evening so that Linus can pull.

Greetings,
Wim.

