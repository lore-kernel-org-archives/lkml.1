Return-Path: <linux-kernel-owner+w=401wt.eu-S1752409AbZLaAxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbZLaAxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 19:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZLaAxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 19:53:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbZLaAxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 19:53:32 -0500
Date: Wed, 30 Dec 2009 19:53:05 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: record relocation offset
Message-ID: <20091231005305.GA3221@redhat.com>
References: <vxv6sfpjggfx6v68yv1eecrx.1262215615671@email.android.com> <1262216506.2749.254.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262216506.2749.254.camel@mulgrave.site>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

james wrote:

> The reasons I gave was why _text relocation didn't work properly for
> systemtap.  The first paragraph was just giving a precis of history
> [...]

The issues you listed (kernel .init sections, modules) have nothing to
do with kernel relocation, and systemtap has apprx. never had problem
calculating relevant addresses in their presence.  The systemtap
problem you are probably thinking of relates to the kernel's former
inability to insert kprobes within .init sections.

- FChE
