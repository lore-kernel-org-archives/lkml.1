Return-Path: <linux-kernel-owner+w=401wt.eu-S1759854AbXIXUPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759854AbXIXUPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbXIXUP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:15:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbXIXUP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:15:28 -0400
Message-ID: <46F81ADD.1030205@redhat.com>
Date: Mon, 24 Sep 2007 16:15:25 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Danny ter Haar <dth@dth.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Q: new kernel not booting (init segfaults) : how to debug ?
References: <20070924192410.GA8881@dth.net>
In-Reply-To: <20070924192410.GA8881@dth.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2007 03:24 PM, Danny ter Haar wrote:
> System: firewall
> -Epia 5000 via c3 system 
> -bios 2.07 (latest available, upgraded from 1.09 with same behaviour)
> -128Mb flash memory (ide emulation)
> -256mb ram
> -voyage linux (debian based)
> Runs "standard" kernel just fine, 2.6.22.17 also compiles/runs
> where as 2.6.23-rcX wont
> 
> Typed over from screenshot:
> 
> ---------------------------------------
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> Using IPI Shortcut mode
> Freeing unused kernel memory: 148k freed
> init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
> init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
> init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
> init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
> init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
> init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
> init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
> init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
> init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
> init[1]: segfault at 85890000 eip 85890000 esp bfcfcb8c error 4
> printk: 788820 messages suppressed.
> ---------------------------------------
> 
> The only thing changed is the kernel.
> I'm just plain flabbergasted about why this occurs and complete
> lost how to debug/persue this any further.
> 
> Kernel config/systemmap etc at http://www.dth.net/kernel/c3/
> 

What address is that in your init?
