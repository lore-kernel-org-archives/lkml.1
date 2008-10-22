Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbYJVP3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbYJVP3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbYJVP3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:29:44 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:43499 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbYJVP3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:29:43 -0400
Date: Wed, 22 Oct 2008 16:29:37 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Glauber Costa <glommer@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip] x86: do_boot_cpu - check if we have ESR register
In-Reply-To: <20081022140009.GA9639@localhost>
Message-ID: <alpine.LFD.1.10.0810221625140.24509@ftp.linux-mips.org>
References: <20081022140009.GA9639@localhost>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:

> We should touch ESR register if only we have it.
> The patch fixes the problem mentoined here
> 
> 	http://lkml.org/lkml/2008/10/17/147
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> CC: Glauber Costa <glommer@gmail.com>
> ---

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

 Note this is one of the few places you can actually write to the ESR 
unconditionally -- there is another similar piece of code elsewhere in 
this file which could get adjusted to look the same as this one after your 
change.  Thanks for this fix.

  Maciej
