Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbZKQOgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbZKQOgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 09:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZKQOgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 09:36:35 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:56391 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbZKQOge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 09:36:34 -0500
Date: Tue, 17 Nov 2009 23:36:35 +0900 (JST)
Message-Id: <20091117.233635.184176449.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
       fweisbec@gmail.com, ling.ma@intel.com
Subject: Re: [PATCH 1/4] perf bench: Add mem-memcpy.c:memcpy() benchmark
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091117125315.GA22668@elte.hu>
References: <20091117112148.GA32578@elte.hu>
	<1258458153-25700-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<20091117125315.GA22668@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/4] perf bench: Add mem-memcpy.c:memcpy() benchmark
Date: Tue, 17 Nov 2009 13:53:15 +0100

> 
> FYI, it fails to build on 32-bit systems, with:
> 
> bench/mem-memcpy.c: In function 'bench_mem_memcpy':
> bench/mem-memcpy.c:118: error: format '%lu' expects type 'long unsigned int', but argument 4 has type 'size_t'

Sorry, I'll fix it.
# This length as argument for fprintf() makes no sense.
# I wonder why I added this...
