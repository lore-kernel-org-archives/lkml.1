Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbYD3VOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbYD3VOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbYD3VN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:13:57 -0400
Received: from www.tglx.de ([62.245.132.106]:58454 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758068AbYD3VN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:13:56 -0400
Date: Wed, 30 Apr 2008 23:13:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oliver Hartkopp <oliver@hartkopp.net>
cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] hrtimer: remove duplicate helper function
In-Reply-To: <4818DEE5.6090405@hartkopp.net>
Message-ID: <alpine.LFD.1.10.0804302313150.6003@apollo.tec.linutronix.de>
References: <4818DEE5.6090405@hartkopp.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver,

On Wed, 30 Apr 2008, Oliver Hartkopp wrote:
> from Oliver Hartkopp <oliver@hartkopp.net>
> 
> The helper function hrtimer_callback_running() is used in kernel/hrtimer.c as
> well as in the updated net/can/bcm.c which now supports hrtimers. Moving the
> helper function to hrtimer.h removes the duplicate definition in the C-files.
> 
> Signed-off-by: Oliver Hartkopp <oliver@hartkopp.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>

Applied. Thanks,

	 tglx
