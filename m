Return-Path: <linux-kernel-owner+w=401wt.eu-S937410AbXGLAOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937410AbXGLAOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937244AbXGLAJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:09:50 -0400
Received: from mx0.towertech.it ([213.215.222.73]:36282 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S936462AbXGLAJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:09:48 -0400
Date: Thu, 12 Jul 2007 02:09:44 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Alex Maclean <monkeh@monkeh.net>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, Tim Gardner <tim.gardner@canonical.com>
Subject: Re: acpi regression on some laptops
Message-ID: <20070712020944.446f3828@i1501.lan.towertech.it>
In-Reply-To: <46955F4D.3090206@monkeh.net>
References: <20070710160056.443ae9ae@i1501.lan.towertech.it>
	<46952CC5.6050800@redhat.com>
	<20070712000124.22d0c3a7@i1501.lan.towertech.it>
	<46955F4D.3090206@monkeh.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 22:53:01 +0000
Alex Maclean <monkeh@monkeh.net> wrote:

> 
> I'm unsure just what hardware you're working with, but try using the 
> option nolapic_timer.

 it worked, thanks!

 hw is a Dell Inspiron 1501, AMD Turion TL52 based.
 drop me a note if you need dmesg or other info.

vendor_id       : AuthenticAMD
cpu family      : 15
model           : 72
model name      : AMD Turion(tm) 64 X2 Mobile Technology TL-52
stepping        : 2

 eax in    eax      ebx      ecx      edx
00000000 00000001 68747541 444d4163 69746e65
00000001 00040f82 01020800 00002001 178bfbff

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

