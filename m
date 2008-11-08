Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYKHJKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYKHJKU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 04:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYKHJKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 04:10:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:58225 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYKHJJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 04:09:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:cc:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=M5Ea5l1cARxjYM9e8DPN2yLu97l/hPLyxzbk21FaurncdWgHsvlcCaZVNMxAvfk9XJ
         UXYGbXuk48d1hrJ8KC+yu8R1uvgJsSZpS4N3gTCYn6+UnG1++dJwdl09vGKfWaEi69Gp
         p5o01UnEn5/gLhXJu8smJXfQvFY2HwBrO7uEQ=
Message-ID: <4915575F.1040103@gmail.com>
Date: Sat, 08 Nov 2008 10:09:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
CC: Gareth Hughes <gareth@valinux.com>, Dave Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel@tungstengraphics.com>
Subject: Re: oops in radeon_suspend (mmotm 2008-10-22-17-18)
References: <49048B88.1060807@gmail.com>
In-Reply-To: <49048B88.1060807@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping

On 10/26/2008 04:23 PM, Jiri Slaby wrote:
> Hi,
> 
> this oops occured on suspend of mmotm:
> http://decibel.fi.muni.cz/~xslaby/radeon_oops1.png
> http://decibel.fi.muni.cz/~xslaby/radeon_oops2.png
> 
> radeon_suspend:
> movq    288(%rcx), %rax # <variable>.mmio, <variable>.mmio
> xorl    %edx, %edx      # tmp68
> movq    24(%rax), %rax  # <variable>.handle, <variable>.handle
> 
> rax (dev_priv->mmio) is null.
