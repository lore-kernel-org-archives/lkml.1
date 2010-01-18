Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679Ab0AREdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab0AREdz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 23:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755658Ab0AREdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 23:33:54 -0500
Received: from mga03.intel.com ([143.182.124.21]:28872 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab0AREdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 23:33:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="233786587"
From: "Wu, Fengguang" <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 18 Jan 2010 12:29:52 +0800
Subject: RE: linux-next: origin tree build warning
Thread-Topic: linux-next: origin tree build warning
Thread-Index: AcqX9K8nTLeDjXATTLaqgP1L5UKDOwAAjGXE
Message-ID: <6CADD16F56BC954D8E28F3836FA7ED7112A9CD50F8@shzsmsx501.ccr.corp.intel.com>
References: <20100118150501.f6aa79e3.sfr@canb.auug.org.au>,<20100118151401.dd8a9ef2.sfr@canb.auug.org.au>
In-Reply-To: <20100118151401.dd8a9ef2.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 15:05:01 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > It actually looks like commit c29af9636 ("sysdev: Pass attribute in
> > sysdev_class attributes show/store") referred to in the changelog for the
> > above commit has not yet been applied to Linus' tree?
>
> Commit c29af9636 ("sysdev: Pass attribute in sysdev_class attributes
> show/store") does appear in linux-next since next-20100111 (in the
> driver-core quilt series - therefore intended for 2.6.34) (it will have a
> different SHA1 today)

So let's queue 8ff410daa009c (sysdev: fix prototype for memory_sysdev_class show/store functions)
in driver-core and delay it to 2.6.34?

Thanks,
Fengguang

