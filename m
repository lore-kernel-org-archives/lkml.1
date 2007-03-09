Return-Path: <linux-kernel-owner+w=401wt.eu-S2993094AbXCIJtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993094AbXCIJtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 04:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993095AbXCIJtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 04:49:13 -0500
Received: from holomorphy.com ([66.93.40.71]:58808 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993094AbXCIJtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 04:49:12 -0500
Date: Fri, 9 Mar 2007 01:49:04 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: Matt Mackall <mpm@selenic.com>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Message-ID: <20070309094904.GC2986@holomorphy.com>
References: <20070309053931.GA10459@waste.org> <200703091728.03978.kernel@kolivas.org> <20070309075358.GA10394@waste.org> <200703091936.47128.kernel@kolivas.org> <87slce945h.fsf@depni.sinp.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87slce945h.fsf@depni.sinp.msu.ru>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 12:07:06PM +0300, Serge Belyshev wrote:
> If you see sched_yield() when stracing any 3d program, I suggest you
> to try this bruteforce workaround, which works fine for me,
> disable sched_yield():

May I suggest LD_PRELOAD of a library consisting of only a nopped
sched_yield() function in userspace?


-- wli
