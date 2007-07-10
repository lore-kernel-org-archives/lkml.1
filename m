Return-Path: <linux-kernel-owner+w=401wt.eu-S1762346AbXGJIel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762346AbXGJIel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbXGJIee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:34:34 -0400
Received: from frankvm.xs4all.nl ([80.126.170.174]:44997 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754874AbXGJIed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:34:33 -0400
Date: Tue, 10 Jul 2007 10:34:32 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Frank van Maarseveen <frankvm@frankvm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22: section mismatch warnings
Message-ID: <20070710083432.GA10878@janus>
References: <20070709184200.GA2496@janus> <20070710001414.GO3492@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710001414.GO3492@stusta.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 02:14:14AM +0200, Adrian Bunk wrote:
> On Mon, Jul 09, 2007 at 08:42:01PM +0200, Frank van Maarseveen wrote:
> >...
> > WARNING: kernel/built-in.o(.text+0x1add5): Section mismatch: reference to .init.text: (between 'kthreadd' and 'init_waitqueue_head')
> 
> Below is the fix in -mm for this (and other issues).

thanks,

Note that these still remain:

WARNING: arch/i386/kernel/built-in.o(.exit.text+0x26): Section mismatch: reference to .init.text: (between 'cache_remove_dev' and 'ffh_cstate_exit')
WARNING: arch/i386/kernel/built-in.o(.data+0xee0): Section mismatch: reference to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mce_work')

-- 
Frank
