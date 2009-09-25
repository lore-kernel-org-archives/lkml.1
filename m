Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZIYAuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZIYAuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZIYAuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:50:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbZIYAuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:50:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jason Baron <jbaron@redhat.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       tglx@linutronix.de, rostedt@goodmis.org, ak@suse.de, rth@redhat.com,
       mhiramat@redhat.com
Subject: Re: [PATCH 2/4] jump label - base patch
In-Reply-To: Jason Baron's message of  Thursday, 24 September 2009 19:17:53 -0400 <98c4c0b11300ac3b7de3acb2096f8f34184b1457.1253831946.git.jbaron@redhat.com>
References: <cover.1253831945.git.jbaron@redhat.com>
	<98c4c0b11300ac3b7de3acb2096f8f34184b1457.1253831946.git.jbaron@redhat.com>
X-Windows: form follows malfunction.
Message-Id: <20090925004938.9D85BE06@magilla.sf.frob.com>
Date: Thu, 24 Sep 2009 17:49:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 5)
> +#define __HAVE_ARCH_JUMP_LABEL
> +#endif

Put this in linux/compiler-gcc4.h (there only test __GNUC_MINOR__).
If icc/whoever adds asm goto they can define it too.


Thanks,
Roland
