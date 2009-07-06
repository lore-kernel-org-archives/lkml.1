Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbZGFVlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbZGFVlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZGFVlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:41:46 -0400
Received: from vpn.pathscale.com ([198.186.3.75]:51353 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753035AbZGFVlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:41:45 -0400
Date: Mon, 06 Jul 2009 14:41:49 -0700
From: john.gregor@qlogic.com (John A. Gregor)
To: hpa@zytor.com
Subject: Re: [PATCH] x86_64/__iowrite32_copy: don't use string move for PIO
 writes
Cc: ralph.campbell@qlogic.com, linux-kernel@vger.kernel.org
Message-ID: <4a526f9d.727WYWXsf6cHuLp3%john.gregor@qlogic.com>
References: <1246907224-22758-1-git-send-email-john.gregor@qlogic.com>
 <4A526CE6.30200@zytor.com>
In-Reply-To: <4A526CE6.30200@zytor.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> wrote:

> John Gregor wrote:
> > From: John Gregor <johng@diamond.mv.qlogic.com>
> > 
> > Some processors can write the same word more than once if the movs
> > instruction is used. This version uses normal memory move instructions
> > and gets the same performance since the speed is limited by PCIe and
> > write combining.
> > 
>
> Which processors do that *when addressing I/O memory*?

More specifically, check out:

http://www.intel.com/Assets/PDF/specupdate/321324.pdf

Errata AAK6

-John Gregor
