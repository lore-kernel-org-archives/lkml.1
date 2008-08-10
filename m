Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYHJRsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYHJRsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 13:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYHJRse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 13:48:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:44382 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbYHJRsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 13:48:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=radXw7VaK3L6uAVwYXNmzZ5rPkGlieDJa8IQBEg7OntSCtV8B4ubUzZhXWQG7umb5X
         TjxmYFc9bLJRuBPmU4BNzTvy+SoEtgYLVb4FFhuKhVRjm84k2DaqbBfoLVrPGvcZcA+1
         sejmy+jllOXbM2rfXgyZ+7ERItLNanJ53s/10=
Message-ID: <84144f020808101048l7d62c133paf320c48748fe514@mail.gmail.com>
Date: Sun, 10 Aug 2008 20:48:33 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 5/5] kmemtrace: SLOB hooks.
Cc: mathieu.desnoyers@polymtl.ca, cl@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net, mpm@selenic.com,
       rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1218388447-5578-6-git-send-email-eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218388447-5578-1-git-send-email-eduard.munteanu@linux360.ro>
	 <1218388447-5578-2-git-send-email-eduard.munteanu@linux360.ro>
	 <1218388447-5578-3-git-send-email-eduard.munteanu@linux360.ro>
	 <1218388447-5578-4-git-send-email-eduard.munteanu@linux360.ro>
	 <1218388447-5578-5-git-send-email-eduard.munteanu@linux360.ro>
	 <1218388447-5578-6-git-send-email-eduard.munteanu@linux360.ro>
X-Google-Sender-Auth: 8b25f57b272ca63a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 8:14 PM, Eduard - Gabriel Munteanu
<eduard.munteanu@linux360.ro> wrote:
> This adds hooks for the SLOB allocator, to allow tracing with kmemtrace.
>
> We also convert some inline functions to __always_inline to make sure
> _RET_IP_, which expands to __builtin_return_address(0), always works
> as expected.
>
> Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

I think Matt acked this already but as you dropped the tags, I'll ask
once more before I merge this.
