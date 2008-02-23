Return-Path: <linux-kernel-owner+w=401wt.eu-S933530AbYBWIvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530AbYBWIvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbYBWIvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:51:11 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:3835 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYBWIvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:51:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=dqpzY/c6i/LqRd/9DKeK7om5ksogKpiCX5Vuj73sWiuRfDXGSCcoFBpGa+35sHEEDPIUmSNQcFdZ6kW+XLeBB0afgxZncIQx67P/0Q1YWnAz85i9KbpVgnwrbj94nSWjm7bLwXq5iKuQRPZFILUpULvJgGV4rkXgX/L3UsmWaR8=
Date: Sat, 23 Feb 2008 11:51:01 +0300
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/16] (Resend) Use get_personality()
Message-ID: <20080223085101.GC2262@martell.zuzino.mipt.ru>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 04:14:03PM +0800, WANG Cong wrote:
> This patchset makes the macro get_personality function alike
> and teaches code to use get_personality() instead of explicit
> reference.
> 
> [I am sorry if you've received multiple copied of this, since
>  my git-send-email doesn't work well. ]

Yes, but why? "current->personality" is way more understandable than
your macro because task subject to dereference is very visible.
