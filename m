Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbYFBJVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbYFBJVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbYFBJVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:21:46 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:47891 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750862AbYFBJVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:21:46 -0400
Date: Mon, 2 Jun 2008 18:21:44 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>,
       xen-devel <xen-devel@lists.xensource.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10 of 12] xen: implement save/restore
Message-ID: <20080602092144.GA22955%yamahata@valinux.co.jp>
References: <patchbomb.1211550067@localhost> <9e8d06e5ae8024829836.1211550077@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e8d06e5ae8024829836.1211550077@localhost>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 02:41:17PM +0100, Jeremy Fitzhardinge wrote:
> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
...
> +static int xen_suspend(void *data)
> +{
> +	int *cancelled = data;
> +
> +	BUG_ON(!irqs_disabled());
> +
> +	load_cr3(swapper_pg_dir);

What is the purpose of load_cr3() here?
I'd like to make this load_cr3() more arch generic for ia64 support.
(or eliminate it if possible)
-- 
yamahata
