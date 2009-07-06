Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbZGFVhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbZGFVhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbZGFVgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:36:52 -0400
Received: from vpn.pathscale.com ([198.186.3.75]:40479 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754073AbZGFVgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:36:52 -0400
Date: Mon, 06 Jul 2009 14:36:55 -0700
From: john.gregor@qlogic.com (John A. Gregor)
To: hpa@zytor.com
Subject: Re: [PATCH] x86_64/__iowrite32_copy: don't use string move for PIO
 writes
Cc: ralph.campbell@qlogic.com, linux-kernel@vger.kernel.org,
       johng@diamond.mv.qlogic.com
Message-ID: <4a526e77.IPiyTZWRWfll2+00%john.gregor@qlogic.com>
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

Nehalem.

-John Gregor
