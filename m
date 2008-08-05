Return-Path: <linux-kernel-owner+w=401wt.eu-S1762197AbYHEXGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762197AbYHEXGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbYHEXFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:05:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:56600 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753830AbYHEXFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:05:23 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX18ZwzpHT3AZ/yuYVN1bs4jFcioAX2Zf7QDnYHCSWx
	MnPCvK96QD+k55
Date: Wed, 6 Aug 2008 01:05:20 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, shaohua.li@intel.com
Subject: Re: BUG when doing a cat
	/sys/devices/system/cpu/cpuidle/current_driver
Message-ID: <20080805230520.GA14978@alice>
References: <20080805111836.GB12217@alice> <20080805123356.GA12656@alice> <20080805175224.GA1745@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080805175224.GA1745@debian>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.26 (x86_64)
X-Uptime: 01:04:52 up 1 day,  9:47,  4 users,  load average: 0.00, 0.02,
	0.10
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.8100000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rabin Vincent (rabin@rab.in) wrote:
> 
> The problem is that the sysfs attributes are incorrectly declared.  The
> patch below should fix it:

thanks, the patch works fine

greetings, eric
