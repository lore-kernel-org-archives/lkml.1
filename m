Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbYKCOu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbYKCOu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbYKCOuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:50:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:4482 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbYKCOut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:50:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J4Wf9ZUKoQULJQfUMQk3OHNLNhbxIjR0/yU/yVKw/uLIoDzPKfq6CfTfwfnv+X1gQl
         TjwAVrdtdL5IJN7J1isK+Q5RZdlxn3jv7UpJt73uotVkoyrbZ+oprO5FI0K5xIzDWxho
         Qh1wt/IkdIVY3Wj6B0gZIDj6OxAamT/oX5TZg=
Date: Mon, 3 Nov 2008 17:54:05 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, mingo@elte.hu
Subject: next-20081103: voyager
Message-ID: <20081103145405.GA13851@x200.localdomain>
References: <20081103183214.aac32543.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103183214.aac32543.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On i386-voyager:

  CC      arch/x86/mach-voyager/setup.o
arch/x86/mach-voyager/setup.c: In function 'intr_init_hook':
arch/x86/mach-voyager/setup.c:30: error: implicit declaration of function 'smp_intr_init'
arch/x86/mach-voyager/setup.c: In function 'machine_specific_memory_setup':
arch/x86/mach-voyager/setup.c:65: warning: unused variable 'new_nr'
make[2]: *** [arch/x86/mach-voyager/setup.o] Error 1
  CC      arch/x86/mach-voyager/voyager_smp.o
arch/x86/mach-voyager/voyager_smp.c:67: error: conflicting types for 'phys_cpu_present_map'
arch/x86/include/asm/mpspec.h:143: error: previous declaration of 'phys_cpu_present_map' was here
arch/x86/mach-voyager/voyager_smp.c: In function 'start_secondary':
arch/x86/mach-voyager/voyager_smp.c:452: error: implicit declaration of function 'notify_cpu_starting'
arch/x86/mach-voyager/voyager_smp.c: In function 'smp_call_function_interrupt':
arch/x86/mach-voyager/voyager_smp.c:965: error: implicit declaration of function 'generic_smp_call_function_interrupt'
arch/x86/mach-voyager/voyager_smp.c: In function 'smp_call_function_single_interrupt':
arch/x86/mach-voyager/voyager_smp.c:973: error: implicit declaration of function 'generic_smp_call_function_single_interrupt'
