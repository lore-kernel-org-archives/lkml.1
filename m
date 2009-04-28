Return-Path: <linux-kernel-owner+w=401wt.eu-S1762723AbZD1Rur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762723AbZD1Rur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761570AbZD1Ruh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:50:37 -0400
Received: from waste.org ([66.93.16.53]:54054 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759942AbZD1Ruh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:50:37 -0400
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
From: Matt Mackall <mpm@selenic.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20090428014920.769723618@intel.com>
References: <20090428010907.912554629@intel.com>
	 <20090428014920.769723618@intel.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 12:49:21 -0500
Message-Id: <1240940961.938.451.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 09:09 +0800, Wu Fengguang wrote:
> plain text document attachment (kpageflags-extending.patch)
> Export 9 page flags in /proc/kpageflags, and 8 more for kernel developers.

My only concern with this patch is it knows a bit too much about SLUB
internals (and perhaps not enough about SLOB, which also overloads
flags). 

-- 
http://selenic.com : development and support for Mercurial and Linux


