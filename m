Return-Path: <linux-kernel-owner+w=401wt.eu-S1765756AbYBVLeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765756AbYBVLeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 06:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbYBVLeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 06:34:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50903 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbYBVLeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 06:34:23 -0500
Subject: Re: Kernel oops with bluetooth usb dongle
From: David Woodhouse <dwmw2@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Quel Qun <kelk1@comcast.net>, Dave Young <hidave.darkstar@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.1.00.0802220813180.7583@apollo.tec.linutronix.de>
References: <022220080240.25836.47BE362900072A1C000064EC2200761394CE05040A05@comcast.net>
	 <alpine.LFD.1.00.0802220813180.7583@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 20:34:09 +0900
Message-Id: <1203680049.5771.44.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-22 at 08:23 +0100, Thomas Gleixner wrote:
> 
> +       del_timer(&conn->info_timer);
> +
>         hcon->l2cap_data = NULL;
>         kfree(conn);

Shouldn't that be del_timer_sync() ?

-- 
dwmw2

