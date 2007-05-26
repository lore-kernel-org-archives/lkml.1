Return-Path: <linux-kernel-owner+w=401wt.eu-S1762816AbXEZQhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816AbXEZQhQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbXEZQhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:37:05 -0400
Received: from mail.tmr.com ([64.65.253.246]:47769 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbXEZQhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:37:02 -0400
Message-ID: <465862C1.6040006@tmr.com>
Date: Sat, 26 May 2007 12:39:29 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Junio C Hamano <junkio@cox.net>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 2/3] Unify dma blacklist in ide-dma.c and libata-core.c
References: <20070521145042.GA6957@redhat.com>	<20070521171551.0f81a0be@the-village.bc.nu>	<7v3b1pbgeo.fsf_-_@assigned-by-dhcp.cox.net> <7vveela1lv.fsf_-_@assigned-by-dhcp.cox.net>
In-Reply-To: <7vveela1lv.fsf_-_@assigned-by-dhcp.cox.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano wrote:
> This introduces a shared header file that defines the entries
> for two dma blacklists in ide-dma.c and libata-core.c to make it
> easier to keep them in sync.
> 
Why wasn't this done this way in the first place? Out of tree 
development for libata or something?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
