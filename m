Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYKGSw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYKGSw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbYKGSwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:52:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38354 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbYKGSwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:52:44 -0500
Message-ID: <49148E66.4040109@zytor.com>
Date: Fri, 07 Nov 2008 10:52:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [arch/x86/vdso/vdso32-syms.lds] Error 1
References: <20081107181117.GA29006@gentoox2.trippelsdorf.de>
In-Reply-To: <20081107181117.GA29006@gentoox2.trippelsdorf.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Trippelsdorf wrote:
> --- -   2008-11-07 18:51:36.392997346 +0100
> +++ arch/x86/vdso/vdso32-int80-syms.lds 2008-11-07 18:51:36.283820343 +0100
> @@ -3,5 +3,3 @@
>  VDSO32_sigreturn = 0x0400;
>  VDSO32_vsyscall = 0x0420;
>  VDSO32_vsyscall_eh_frame_size = 0x040;
> -VDSO32_vsyscall = 0x0420;
> -VDSO32_vsyscall_eh_frame_size = 0x040;
> make[1]: *** [arch/x86/vdso/vdso32-syms.lds] Error 1
> make: *** [arch/x86/vdso] Error 2
> 

Could you please tar up your arch/x86/vdso directory and send me?

Also, what version of binutils are you running?

	-hpa
