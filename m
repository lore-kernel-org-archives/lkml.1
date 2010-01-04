Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158Ab0ADMhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab0ADMhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 07:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524Ab0ADMhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 07:37:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:58140 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab0ADMhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 07:37:50 -0500
Date: Mon, 4 Jan 2010 04:40:24 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: volano ~30% regression with 2.6.33-rc1 & -rc2
Message-ID: <20100104044024.5390ff1c@infradead.org>
In-Reply-To: <1262592958.22471.104.camel@minggr.sh.intel.com>
References: <1262592958.22471.104.camel@minggr.sh.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Jan 2010 16:15:58 +0800
Lin Ming <ming.m.lin@intel.com> wrote:

> Mike & Peter,
> 
> Compared with 2.6.32, volano has ~30% regression with 2.6.33-rc1 &
> -rc2. Testing machine: Tigerton Xeon, 16cpus(4P/4Core), 16G memory

did this show up only on this cpu?
(since this is a multi-core-without-shared-cache cpu, it could be that
we get the topology wrong and think cores share cache where they don't)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
