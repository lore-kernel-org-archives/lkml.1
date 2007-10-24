Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbXJXHp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbXJXHp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 03:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbXJXHpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 03:45:12 -0400
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:60364 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbXJXHpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 03:45:11 -0400
Date: Wed, 24 Oct 2007 09:44:27 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>
Subject: kvm_main.c:220: error: implicit declaration of function
 'smp_call_function_mask'
Message-ID: <20071024094427.31e3364a@localhost>
In-Reply-To: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      drivers/kvm/kvm_main.o
drivers/kvm/kvm_main.c: In function 'kvm_flush_remote_tlbs':
drivers/kvm/kvm_main.c:220: error: implicit declaration of function 'smp_call_function_mask'
make[2]: *** [drivers/kvm/kvm_main.o] Error 1
make[1]: *** [drivers/kvm] Error 2
make: *** [drivers] Error 2

-----------

"smp_call_function_mask" is defined only on "CONFIG_SMP" but kvm uses it
unconditionally, oops!

-- 
	Paolo Ornati
	Linux 2.6.23-ge8b8c977 on x86_64
