Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZAKVui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZAKVui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZAKVu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:50:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53641
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751746AbZAKVu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:50:28 -0500
Date: Sun, 11 Jan 2009 13:50:29 -0800 (PST)
Message-Id: <20090111.135029.199678338.davem@davemloft.net>
To: travis@sgi.com
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, mingo@elte.hu, rusty@rustcorp.com.au
Subject: Re: cpumask change causes sparc build bustage
From: David Miller <davem@davemloft.net>
In-Reply-To: <496A232A.5070801@sgi.com>
References: <20090111205008.db0a410e.sfr@canb.auug.org.au>
	<20090111.040640.188129980.davem@davemloft.net>
	<496A232A.5070801@sgi.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Travis <travis@sgi.com>
Date: Sun, 11 Jan 2009 08:49:46 -0800

> Thanks for fixing it.  In actuality though, it should return cpu_mask_all
> instead of CPU_MASK_ALL_PTR but that's a small nit.

CPU_MASK_ALL_PTR is defined to &cpu_mask_all, that's why I used it, to
be consistent with the other macro using CPU_MASK_ALL right above it.
