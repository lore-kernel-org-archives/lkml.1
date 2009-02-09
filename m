Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbZBIT4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbZBIT4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbZBIT4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:56:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:48855 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZBIT4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:56:43 -0500
Message-ID: <49908A5A.4010600@kernel.org>
Date: Mon, 09 Feb 2009 11:56:10 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: warning about phys_addr_t
References: <4990892D.90008@kernel.org>
In-Reply-To: <4990892D.90008@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> looks virt_to_phys will return phys_addr_t instead of unsigned long now?
> 
> arch/x86/kernel/mpparse.c: In function ‘smp_scan_config’:
> arch/x86/kernel/mpparse.c:696: warning: format ‘%08lx’ expects type ‘long unsigned int’, but argument 3 has type ‘phys_addr_t’
> arch/x86/kernel/mpparse.c: In function ‘update_mp_table’:
> arch/x86/kernel/mpparse.c:1014: warning: format ‘%lx’ expects type ‘long unsigned int’, but argument 2 has type ‘phys_addr_t’
> 

also
drivers/net/sfc/falcon.c: In function ‘falcon_alloc_special_buffer’:
drivers/net/sfc/falcon.c:340: warning: format ‘%lx’ expects type ‘long unsigned int’, but argument 10 has type ‘phys_addr_t’
drivers/net/sfc/falcon.c: In function ‘falcon_free_special_buffer’:
drivers/net/sfc/falcon.c:355: warning: format ‘%lx’ expects type ‘long unsigned int’, but argument 10 has type ‘phys_addr_t’
drivers/net/sfc/falcon.c: In function ‘falcon_probe_port’:
drivers/net/sfc/falcon.c:2346: warning: format ‘%lx’ expects type ‘long unsigned int’, but argument 7 has type ‘phys_addr_t’
drivers/net/sfc/falcon.c: In function ‘falcon_probe_nic’:
drivers/net/sfc/falcon.c:2924: warning: format ‘%lx’ expects type ‘long unsigned int’, but argument 7 has type ‘phys_addr_t’


drivers/firmware/iscsi_ibft.c: In function ‘ibft_init’:
drivers/firmware/iscsi_ibft.c:942: warning: format ‘%lx’ expects type ‘long unsigned int’, but argument 2 has type ‘phys_addr_t’


YH
