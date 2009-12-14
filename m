Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbZLNKhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbZLNKhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 05:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbZLNKhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 05:37:40 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:59761 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbZLNKhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 05:37:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FM9VqHeDKujXICCThu8Sm1gA1/5Ihjpgq2z82mJr/xbcRFpMAQAYNnuRCWGobpVV2x
         D+g5nlX01MkrQHxfpArm7WBZ0H0l/kxaCgonQJE3xZtZEnWg0MHyRhZszjaSf5IkaGZz
         1BBRjxFyo1lzsjoZbBLUy4lIEbyk90D2PI6fQ=
Date: Mon, 14 Dec 2009 11:37:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] hw-breakpoints: Let
	modify_user_hw_breakpoint() return an int
Message-ID: <20091214103732.GA5068@nowhere>
References: <20091214092412.GA5242@osiris.boeblingen.de.ibm.com> <tip-4983ee49cf0393fd786891dd53af41146cf9f98b@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-4983ee49cf0393fd786891dd53af41146cf9f98b@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 09:49:44AM +0000, tip-bot for Heiko Carstens wrote:
> Commit-ID:  4983ee49cf0393fd786891dd53af41146cf9f98b
> Gitweb:     http://git.kernel.org/tip/4983ee49cf0393fd786891dd53af41146cf9f98b
> Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
> AuthorDate: Mon, 14 Dec 2009 10:24:12 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 14 Dec 2009 10:42:57 +0100
> 
> hw-breakpoints: Let modify_user_hw_breakpoint() return an int
> 
> Let modify_user_hw_breakpoint return an int to avoid hundreds of
> compile warnings like this one:
> 
>  include/linux/hw_breakpoint.h: In function 'modify_user_hw_breakpoint':
>  include/linux/hw_breakpoint.h:96:
>   warning: return makes integer from pointer without a cast
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> LKML-Reference: <20091214092412.GA5242@osiris.boeblingen.de.ibm.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>


Thanks!

I sent a patch for that but looks like it haven't made
its way :)

[PATCH] hw-breakpoints: Handle bad modify_user_hw_breakpoint off-case return value

