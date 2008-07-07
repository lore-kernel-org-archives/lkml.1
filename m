Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbYGGXEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbYGGXEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828AbYGGXEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:04:10 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:58071 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758722AbYGGXEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:04:08 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar4AACY8ckhR8syU/2dsb2JhbAAIsSY
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Stoyan Gaydarov" <stoyboyker@gmail.com>
Subject: Re: Compile Error for 2.6.26-rc9
Date: Tue, 8 Jul 2008 01:04:11 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <6d291e080807061924v4f1bb6a5l387a14509761f50a@mail.gmail.com>
In-Reply-To: <6d291e080807061924v4f1bb6a5l387a14509761f50a@mail.gmail.com>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807080104.11832.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stoyan,

On Monday 07 July 2008, Stoyan Gaydarov wrote:
> While doing a randconfig earlier make failed with this:
>
>   AR      arch/x86/lib/lib.a
>   LD      vmlinux.o
>   MODPOST vmlinux.o
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `uvc_input_cleanup':
> /data/kernels/build-test/linux-2.6.26-rc9/drivers/media/video/uvc/uvc_statu
>s.c:67: undefined reference to `input_unregister_device'
> drivers/built-in.o: In function `uvc_input_init':
> /data/kernels/build-test/linux-2.6.26-rc9/drivers/media/video/uvc/uvc_statu
>s.c:32: undefined reference to `input_allocate_device'
> /data/kernels/build-test/linux-2.6.26-rc9/drivers/media/video/uvc/uvc_statu
>s.c:52: undefined reference to `input_register_device'
> /data/kernels/build-test/linux-2.6.26-rc9/drivers/media/video/uvc/uvc_statu
>s.c:59: undefined reference to `input_free_device'
> drivers/built-in.o: In function `input_report_key':
> /data/kernels/build-test/linux-2.6.26-rc9/include/linux/input.h:1269:
> undefined reference to `input_event'
> make: *** [.tmp_vmlinux1] Error 1
>
> The config file is attached
>
> -Stoyan G

Thanks for the report. I'll post a patch to the video4linux mailing list and 
I'll CC you.

Best regards,

Laurent Pinchart
