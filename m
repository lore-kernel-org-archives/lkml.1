Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbXHXRsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbXHXRsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761198AbXHXRsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:48:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59744 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761031AbXHXRsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:48:43 -0400
Date: Fri, 24 Aug 2007 10:42:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] export i386 smp_call_function_mask() to modules
Message-ID: <20070824104242.2f20e2c9@laptopd505.fenrus.org>
In-Reply-To: <46CEFB03.5040302@bull.net>
References: <46CEFB03.5040302@bull.net>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 17:36:35 +0200
Laurent Vivier <Laurent.Vivier@bull.net> wrote:

> This patch export i386 smp_call_function_mask() with EXPORT_SYMBOL().
> 
> This function is needed by KVM to call a function on a set of CPUs.
> 
>  arch/i386/kernel/smp.c |    7 +++++++
>  include/asm-i386/smp.h |    9 +++------
>  2 files changed, 10 insertions(+), 6 deletions(-)
> 
> Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>

hmm isn't it being an inline also making it available for KVM to use?
If so... isn't your patch description entirely not matching what the
code does?
