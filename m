Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbXLGQb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbXLGQb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 11:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXLGQbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 11:31:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58561 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbXLGQbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 11:31:19 -0500
Date: Fri, 7 Dec 2007 17:31:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Message-ID: <20071207163116.GB5992@one.firstfloor.org>
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207160439.71b7f46a@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You don't need to. Port 0x80 historically is about 8uS so just udelay(8)
> and make sure the initial default delay is conservative enough before the

How would you make it conservative enough handling let's say a 6Ghz CPU
that can execute multiple jumps per cycle?

-Andi
