Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbXLLVbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbXLLVbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbXLLVbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:31:44 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:40759 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbXLLVbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:31:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WnnyioR4gIoIcWqKPpLyRCbHnaT0Ost9rl+PVXJ1UW0bj599VvMHBl4qt13vxzV3078dSiKDATB4+L8hb9BAjk1OBRiMDgHCJGgM80/a5RVLzR7lZL+8tYD4usuVYFTSwh90hV5/qYuW1Brox5L1IAfDIZRPwp/4Lzn38GLaEOg=
Subject: Re: [PATCH] x86: Remove all definitions with fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <47605238.9020402@cfl.rr.com>
References: <1197491364.21291.14.camel@brick>  <47605238.9020402@cfl.rr.com>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 13:31:42 -0800
Message-Id: <1197495102.21291.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-12 at 16:27 -0500, Phillip Susi wrote:
> Harvey Harrison wrote:
> > fastcall is always defined to be empty, remove it from arch/x86
> 
> Why is it always defined to be empty?  Why isn't it used anymore?
> 

It was a leftover from before regparm(3) became the default on x86-32.

It doesn't have any use now.

Harvey

