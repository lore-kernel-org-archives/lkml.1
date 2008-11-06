Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYKFWdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYKFWdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYKFWc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:32:58 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:47331 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYKFWc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:32:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C4imF3KiNfSaW60B8zDtUSoh2QUrclCH1n75L07c+miwnyb2Nrkc68XVIDAqYG2UMK
         zuvj29BZgJJnSUq14vO1lbOfUzaMV0NxKrZ29NsYLF+L+KdRy8jnK4bQwpVj1Ke5eMi6
         otKOkbUIcXIqbRzrHzxr2xterRCVp8Lqlpuew=
Date: Fri, 7 Nov 2008 01:36:15 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/1] ftrace: split out hardirq ftrace code into own
	header
Message-ID: <20081106223615.GB26686@x200.localdomain>
References: <20081106211949.320119144@goodmis.org> <20081106212041.790862958@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106212041.790862958@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 04:19:50PM -0500, Steven Rostedt wrote:
> -#include <linux/ftrace.h>
> +#include <linux/ftrace_irq.h>

This helps, please don't forget in merge compile fixes into original patches
before pleasepulling.
