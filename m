Return-Path: <linux-kernel-owner+w=401wt.eu-S1751368AbZL0JAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbZL0JAA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 04:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZL0I77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 03:59:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36522 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZL0I76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 03:59:58 -0500
Subject: Re: tbench regression with 2.6.33-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Lin Ming <ming.m.lin@intel.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1261902760.6201.33.camel@marge.simson.net>
References: <1261739467.10685.18.camel@minggr.sh.intel.com>
	 <1261902760.6201.33.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Dec 2009 09:59:09 +0100
Message-ID: <1261904349.15854.2.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-27 at 09:32 +0100, Mike Galbraith wrote:
> Perf also isn't free, and in 33, we lost the ability to config it out,

Uhm, that's a plain bug, we should be able to build a kernel without
perf support, does the hw breakpoint support have an unfortunate select
some place or something?

