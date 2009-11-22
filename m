Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbZKVGTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbZKVGTy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 01:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZKVGTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 01:19:54 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:62064 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZKVGTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 01:19:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=vel+NNd38R8RcQa6aKhR0hD+6we9vlqHJBrdpoZRmZlvl3KdS1zIL19jNWKyPVRz0x
         lQar2sN8h6n7P16otf1iWHhiGDIPQBtEQZemS0u473PI5tCsPO1qvdy3fSj+aZPvEqO1
         c0YtasRrRI7wO09ViXpWNAT/v4AfVQBD6Vow4=
Subject: Re: [PATCH v9 07/10] tracing: add dynamic function graph tracer
 for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: rostedt@goodmis.org, Nicholas Mc Guire <der.herr@hofr.at>,
       zhangfx@lemote.com, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
In-Reply-To: <20091120172438.GG6869@linux-mips.org>
References: <cover.1258719323.git.wuzhangjin@gmail.com>
	 <c08257b0ef370f6e04ff9719bf7499bae28c70f4.1258719323.git.wuzhangjin@gmail.com>
	 <20091120172438.GG6869@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Sun, 22 Nov 2009 14:19:37 +0800
Message-ID: <1258870777.2833.2.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 17:24 +0000, Ralf Baechle wrote:
> On Fri, Nov 20, 2009 at 08:34:35PM +0800, Wu Zhangjin wrote:
> 
> > From: Wu Zhangjin <wuzhangjin@gmail.com>
> > 
> > This patch make function graph tracer work with dynamic function tracer.
> > 
> > To share the source code of dynamic function tracer(MCOUNT_SAVE_REGS),
> > and avoid restoring the whole saved registers, we need to restore the ra
> > register from the stack.
> > 
> > (NOTE: This not work with 32bit! need to ensure why!)
> > 

Hi, Ralf, Could you please remove the above "NOTE", just test your
-queue repository with the latest sched_clock() in 32bit, it works well.
so, that NOTE is out-of-date.

Thanks & Best Regards,
	Wu Zhangjin

