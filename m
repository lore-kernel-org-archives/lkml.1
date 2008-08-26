Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbYHZISp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbYHZISp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYHZISf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:18:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:20312 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbYHZISe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:18:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=R/TmY6i/lVyZ0ZXI+ABK+mWKVj8Mn2I8StWAJtnscEXB9KFPsFYhkh55RTN1NIUCog
         NGv/zaeymjw4pf4qWhCNFY+Dr/ZJcujboSP/1WG+T+abrkf9il3gTSGIeH9s9xA+1tq5
         JXu+g1Z77xU8fEfwtdi4FxyON5E8w0GzEA/fg=
Message-ID: <86802c440808260118x245a9429ldf64a26ec3d1b3bf@mail.gmail.com>
Date: Tue, 26 Aug 2008 01:18:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: x86: move kstat_irqs from kstat to irq_desc - fix
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Stephen Rothwell" <sfr@canb.auug.org.au>
In-Reply-To: <20080826081351.GA12150@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219693279-22803-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080826081351.GA12150@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 1:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> fix broken with kstat when rebasing sparse_irq
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> applied to tip/irq/sparseirq, thanks Yinghai.
>
> will this fix the powerpc build breakage reported by Stephen?
>

yes.

maybe you need to squash it into
x86: move kstat_irqs from kstat to irq_desc

YH
