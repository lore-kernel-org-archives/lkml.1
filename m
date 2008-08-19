Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYHSBb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYHSBb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYHSBbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:31:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:53112 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbYHSBbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:31:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=p2H9zmovW7NmAQDA9CN/I6Sa6o4l0DnZHUPlNojB4VQjBFI7u7/rTz32IvbpkDikZt
         yafN3AbKB6Q5KGO4LH01KURzp5M78vdgQJzOW8n+Z22CdQ3lmSsMl3zkstYyRQo4vrL8
         vT+VLNH4QtkeZHrUUmi53Otai3TV8OEXGKX6k=
Message-ID: <86802c440808181831o6c69a8bj58914800fb691721@mail.gmail.com>
Date: Mon, 18 Aug 2008 18:31:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: probe nr_irqs even only mptable is used
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080819012044.GE14821@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219108476-30501-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080819012044.GE14821@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 6:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> for !CONFIG_HAVE_SPARSE_IRQ
>
> applied to tip/irq/sparseirq, thanks.
>
> This should fix MAXSMP+!SPARSEIRQ bootups and memory footprint, right?
>

Yes

YH
