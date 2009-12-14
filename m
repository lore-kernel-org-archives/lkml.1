Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbZLNOpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbZLNOpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZLNOpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:45:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45248 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbZLNOpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:45:19 -0500
Subject: Re: [PATCH] sched: Use pr_fmt and pr_<level>
From: Peter Zijlstra <peterz@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1260655047.2637.7.camel@Joe-Laptop.home>
References: <1260655047.2637.7.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 14 Dec 2009 15:45:17 +0100
Message-ID: <1260801917.4165.324.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-12 at 13:57 -0800, Joe Perches wrote:
> Convert printk(KERN_<level> to pr_<level> (not KERN_DEBUG)
> Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> Coalesce long format strings
> Add missing \n to "ERROR: !SD_LOAD_BALANCE domain has parent"

I really utterly hate these patches, but whatever.. :-(
