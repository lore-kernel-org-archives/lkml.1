Return-Path: <linux-kernel-owner+w=401wt.eu-S970087AbXHMQKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970087AbXHMQKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947351AbXHMOsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:48:33 -0400
Received: from www.osadl.org ([213.239.205.134]:48499 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S945262AbXHMOsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:48:30 -0400
Subject: Re: 2.6.23-rc3-hrt1 fails to compile
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Saitz <Ingo.Saitz@stud.uni-hannover.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070813125417.GA32654@schwan.zoo>
References: <20070813125417.GA32654@schwan.zoo>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 16:48:25 +0200
Message-Id: <1187016505.12828.113.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 14:54 +0200, Ingo Saitz wrote:
> This is a clean 2.6.23-rc3-hrt1 with no additional patches, .config
> attached. make bzImage stops at:
> 
>   LD      drivers/acpi/resources/built-in.o
>   CC      drivers/acpi/sleep/poweroff.o
>   CC      drivers/acpi/sleep/wakeup.o
>   CC      drivers/acpi/sleep/main.o
>   CC      drivers/acpi/sleep/proc.o
>   LD      drivers/acpi/sleep/built-in.o
> make[3]: *** No rule to make target `drivers/acpi/tables/tbxface.o', needed by `drivers/acpi/tables/built-in.o'.  Stop.
> make[2]: *** [drivers/acpi/tables] Error 2
> make[1]: *** [drivers/acpi] Error 2
> make: *** [drivers] Error 2
> 
> There is no file named "*tbxface*" in the source.

Fixed in -hrt2

Thanks,
	tglx


