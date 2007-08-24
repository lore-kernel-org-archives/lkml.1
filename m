Return-Path: <linux-kernel-owner+w=401wt.eu-S1762128AbXHXMdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762128AbXHXMdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758606AbXHXMd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:33:29 -0400
Received: from ns1.suse.de ([195.135.220.2]:39342 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758589AbXHXMd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:33:28 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [PATCH][RESEND] Implement missing x86_64 function smp_call_function_mask()
Date: Fri, 24 Aug 2007 14:33:23 +0200
User-Agent: KMail/1.9.6
Cc: discuss@x86-64.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>
References: <46CD38E5.4000704@bull.net> <20070823105628.GM8058@bingen.suse.de> <46CEBF55.3070703@bull.net>
In-Reply-To: <46CEBF55.3070703@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708241433.24024.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2007 13:21:57 Laurent Vivier wrote:
> This patch defines the missing function smp_call_function_mask() for x86_64,
> this is more or less a cut&paste of i386 function. It removes also some
> duplicate code.
> 
> This function is needed by KVM to execute a function on all CPUs.
> 
>  arch/x86_64/kernel/smp.c |  118 ++++++++++++++++++++++++-----------------------
>  include/asm-x86_64/smp.h |    2
>  2 files changed, 64 insertions(+), 56 deletions(-)
> 
> Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>


Applied thanks
-Andi
 


