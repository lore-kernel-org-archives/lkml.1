Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbYJSPzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbYJSPzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 11:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYJSPzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 11:55:41 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:36110 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751440AbYJSPzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 11:55:41 -0400
Subject: Re: Regression in 2.6.27: "irq 18: nobody cared" on Toshiba
	Satellite A100
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: "M. Vefa Bicakci" <bicave@superonline.com>,
       Olaf Dabrunz <odabrunz@suse.de>, Stefan Assmann <sassmann@suse.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48FB3ED5.60904@superonline.com>
References: <48FB3ED5.60904@superonline.com>
Content-Type: text/plain
Organization: Novell
Date: Sun, 19 Oct 2008 08:55:22 -0700
Message-Id: <1224431722.26279.4.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-19 at 10:06 -0400, M. Vefa Bicakci wrote:
> Hello,
> 
> As you might guess from the subject line, since I started to use 2.6.27-rcX
> series, I began to get "irq 18: nobody cared" messages in dmesg. Currently I am
> using 2.6.27.2 with Sidux on this laptop, which is a Toshiba Satellite A100.
> I have reproduced this problem with vanilla and sidux's kernels.
> 

Can you provide the contents of /proc/interrupts? 

If you can reproduce the keyboard issue, it would be helpful to have the
above a few seconds before and after the device failure.

> 
> Note 2: Another interesting thing which might be relevant is the following
> message which appears in dmesg some time after I boot:
> 
> --- 8< ---
> hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
> --- >8 ---
> 

Is this card using IRQ 18?

Thanks,

Sven


> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

