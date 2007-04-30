Return-Path: <linux-kernel-owner+w=401wt.eu-S1030958AbXD3LXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030958AbXD3LXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030948AbXD3LXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:23:10 -0400
Received: from mail.suse.de ([195.135.220.2]:55219 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030988AbXD3LXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:23:08 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH] i386: avoid redundant preempt_disable in __unlazy_fpu
Date: Mon, 30 Apr 2007 13:23:05 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <4635D01A.40806@web.de>
In-Reply-To: <4635D01A.40806@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301323.05459.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 April 2007 13:16:42 Jan Kiszka wrote:
> There are two callers of __unlazy_fpu, unlazy_fpu and __switch_to, and
> none of them appear to require additional preempt_disable/enable here.
> Let's open-code save_init_fpu in __unlazy_fpu to save a few ops.

Both patches added thanks
-Andi
