Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbYDCM6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbYDCM6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 08:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbYDCM6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 08:58:24 -0400
Received: from saeurebad.de ([85.214.36.134]:50282 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbYDCM6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 08:58:23 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@elte.hu,
       davem@davemloft.net, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.net,
       takata@linux-m32r.org, ralf@linux-mips.org, kyle@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: Re: [RFC 10/22] m68k: Use generic show_mem()
References: <12071688283927-git-send-email-hannes@saeurebad.de>
	<1207168941186-git-send-email-hannes@saeurebad.de>
	<Pine.LNX.4.64.0804030939320.9848@anakin>
Date: Thu, 03 Apr 2008 14:58:15 +0200
In-Reply-To: <Pine.LNX.4.64.0804030939320.9848@anakin> (Geert Uytterhoeven's
	message of "Thu, 3 Apr 2008 09:40:50 +0200 (CEST)")
Message-ID: <87myobp02g.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> The new version no longer prints
>
>> -	printk("Free swap:       %6ldkB\n", nr_swap_pages<<(PAGE_SHIFT-10));
>

show_mem()
 show_free_areas()
  show_swap_cache_info()
   printk("Free swap  = %lukB\n", nr_swap_pages << (PAGE_SHIFT - 10));

> and
>
>> -	printk("%d free pages\n",free);
>
> on m68k.

show_free_areas() prints global_page_state(NR_FREE_PAGES).  Isn't this
the same?

Thanks,

	Hannes
