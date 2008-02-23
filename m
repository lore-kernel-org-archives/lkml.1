Return-Path: <linux-kernel-owner+w=401wt.eu-S1764301AbYBWIpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764301AbYBWIpH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbYBWIox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:44:53 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:36657 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYBWIov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:44:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O5b60CLSNdgTvdTQNip+S4VGbTM+oOVICu+WCQxHBnW3sSdgd2F9D5zk+rCNtKKtgo2INQIExx26Gtv6h3d1zV7bEVTG4xBIazlhZTs8SrdDXgZxfAzXwXHKD9bp+ObtwztYzaumxWA++sqwYNFBxltdqkDX1BuLep3DPOMuPNw=
Message-ID: <86802c440802230044sbfc909t656aadf5729b31c2@mail.gmail.com>
Date: Sat, 23 Feb 2008 00:44:49 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Q] x86 - boot/header.S
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080223082026.GA6747@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080223082026.GA6747@cvg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 12:20 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> Hi Peter, Sam,
>
>  could you take a look on x86/boot/header.S:280 please?
>
>  # Zero the bss
>         movw    $__bss_start, %di
>         movw    $_end+3, %cx
>         xorl    %eax, %eax
>         subw    %di, %cx
>         shrw    $2, %cx
>         rep; stosl
>
>  I wonder why is $_end there instead of $__bss_stop?
>  Well, accroding to vmlinux_32.lsd both _end and __bss_stop
>  are the same BUT __bss_stop is more convenient methink.
>  Would it be usefull to change?

we should have head32.c like head64.c
and x86_32_start_kernel.

Eric's patch long time ago...

YH
