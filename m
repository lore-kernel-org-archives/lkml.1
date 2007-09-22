Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbXIVTYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbXIVTYH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 15:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXIVTX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 15:23:56 -0400
Received: from www.osadl.org ([213.239.205.134]:59698 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751338AbXIVTX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 15:23:56 -0400
Subject: Re: [PATCH] [31/50] x86_64: honor notify_die() returning
	NOTIFY_STOP
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
Cc: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070921223230.D0C8013DCD@wotan.suse.de>
References: <200709221231.836138000@suse.de>
	 <20070921223230.D0C8013DCD@wotan.suse.de>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 21:23:54 +0200
Message-Id: <1190489034.4035.98.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-22 at 00:32 +0200, Andi Kleen wrote:
> -	notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV);
> +	if (notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)

80 chars please.

	tglx


