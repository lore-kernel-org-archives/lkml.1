Return-Path: <linux-kernel-owner+w=401wt.eu-S1765166AbYEGVm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765166AbYEGVm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYEGVmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:42:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:17583 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbYEGVmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:42:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xfTw4M9+JHxv2SUqqQF9geG/yLPsQV+9txB8T8jjsCUZop0Ymfl1XTvTJb/bMukZdoqYUSsmsj4xodP9eDo4Vj/4yDj/f0tB/uBCCQo76k+OI7bEQ9Wb2OPkhwarPjEDSgLuXuz6QsImtWn7I5Xc8PhmVYpTJzTKn6zPNR95RXc=
Message-ID: <86802c440805071442g212ccad5mffaed7cc069eaf48@mail.gmail.com>
Date: Wed, 7 May 2008 14:42:07 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rufus & Azrael" <rufus-azrael@numericable.fr>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with xf86MapVidMem error
Cc: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <481D72A7.10901@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <481D72A7.10901@numericable.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2008 at 1:24 AM, Rufus & Azrael
<rufus-azrael@numericable.fr> wrote:
> When upgrading to 2.6.25-git18 and above kernel this Xorg error occurs :
>
>  xf86MapVidMem: Could not mmap framebuffer (0xf0000000,0x8000000) (Invalid
> argument)
>
>  The latest working kernel was 25-git17 and perhaps is it related to
> http://lkml.org/lkml/2008/4/28/52
>
>  My .config and Xorg-log files are attached.
>
>  Best regards.
>
...
>  (II) Bus 1 non-prefetchable memory range:
>         [0] -1  0       0xfe900000 - 0xfeafffff (0x200000) MX[B]
>  (II) Bus 1 prefetchable memory range:
>         [0] -1  0       0xf0000000 - 0xf7ffffff (0x8000000) MX[B]
..
>  (II) Active PCI resource ranges:
>         [0] -1  0       0xfebff000 - 0xfebfffff (0x1000) MX[B]
>         [1] -1  0       0xfe8f4000 - 0xfe8f7fff (0x4000) MX[B]
>         [2] -1  0       0xfe8ff000 - 0xfe8ff0ff (0x100) MX[B]
>         [3] -1  0       0xfe8fa000 - 0xfe8fafff (0x1000) MX[B]
>         [4] -1  0       0xfe8fb000 - 0xfe8fbfff (0x1000) MX[B]
>         [5] -1  0       0xfe8fc000 - 0xfe8fcfff (0x1000) MX[B]
>         [6] -1  0       0xfe8fd000 - 0xfe8fdfff (0x1000) MX[B]
>         [7] -1  0       0xfe8fe000 - 0xfe8fefff (0x1000) MX[B]
>         [8] -1  0       0xfe8ff800 - 0xfe8ffbff (0x400) MX[B]
>         [9] -1  0       0xfe900000 - 0xfe9fffff (0x100000) MX[B](B)
>         [10] -1 0       0xfeaf0000 - 0xfeafffff (0x10000) MX[B](B)
>         [11] -1 0       0xf0000000 - 0xf7ffffff (0x8000000) MX[B](B)
>         [12] -1 0       0x0000e800 - 0x0000e8ff (0x100) IX[B]
>         [13] -1 0       0x0000ff00 - 0x0000ff0f (0x10) IX[B]
>         [14] -1 0       0x000001f0 - 0x000001f0 (0x1) IX[B]
>         [15] -1 0       0x000001f0 - 0x000001f7 (0x8) IX[B]
>         [16] -1 0       0x000001f0 - 0x000001f0 (0x1) IX[B]
>         [17] -1 0       0x000001f0 - 0x000001f7 (0x8) IX[B]
>         [18] -1 0       0x00000b00 - 0x00000b0f (0x10) IX[B]
>         [19] -1 0       0x00008000 - 0x0000800f (0x10) IX[B]
>         [20] -1 0       0x00009000 - 0x00009003 (0x4) IX[B]
>         [21] -1 0       0x0000a000 - 0x0000a007 (0x8) IX[B]
>         [22] -1 0       0x0000b000 - 0x0000b003 (0x4) IX[B]
>         [23] -1 0       0x0000c000 - 0x0000c007 (0x8) IX[B]
>         [24] -1 0       0x0000d000 - 0x0000d0ff (0x100) IX[B](B)

what is your /proc/mtrr?

YH
