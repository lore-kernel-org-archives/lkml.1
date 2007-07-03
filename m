Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbXGCUiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbXGCUiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758222AbXGCUiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:38:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758971AbXGCUh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:37:56 -0400
Message-ID: <468AB390.7000608@redhat.com>
Date: Tue, 03 Jul 2007 16:37:36 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 06/10] Immediate Value - i386 Optimization
References: <20070703164046.645090494@polymtl.ca> <20070703164515.071300768@polymtl.ca> <468A9956.9050903@zytor.com> <20070703191605.GB4047@Krystal> <468AAF1F.6010909@zytor.com>
In-Reply-To: <468AAF1F.6010909@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2007 04:18 PM, H. Peter Anvin wrote:
> 
> One could, though, use an indirect jump to achieve, if not as good, at
> least most of the effect:
> 
> 	movl	$<patchable>,<reg>
> 	jmp	*<reg>
> 

Yeah, but there's this GCC bug:

	http://gcc.gnu.org/bugzilla/show_bug.cgi?id=22448

You can't even dereference labels in an ASM statement.
