Return-Path: <linux-kernel-owner+w=401wt.eu-S933566AbXGKWBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566AbXGKWBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763452AbXGKWB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:01:29 -0400
Received: from mx0.towertech.it ([213.215.222.73]:50212 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1763409AbXGKWB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:01:28 -0400
Date: Thu, 12 Jul 2007 00:01:24 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, Tim Gardner <tim.gardner@canonical.com>
Subject: Re: acpi regression on some laptops
Message-ID: <20070712000124.22d0c3a7@i1501.lan.towertech.it>
In-Reply-To: <46952CC5.6050800@redhat.com>
References: <20070710160056.443ae9ae@i1501.lan.towertech.it>
	<46952CC5.6050800@redhat.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 15:17:25 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> >  I'm trying to debug it.. any help/pointers are appreciated. I dont't
> >  have a deep knowledge of the subsystems involved.
> 
> What options did you try?
> 
>   nohpet
>   nohz=off
>   highres=off
> 
> Should be tried in various combinations.

 Hi,

   I tried all the permutations of the above with the same result:
 the kernel hangs at NET: Registering protocol family 2.

 With nolapic it hangs at APIC: Using PIC for interrupt routing

 With acpi=off it boots but, obviously, everything acpi related
 does not work.
 
 anything else I can try? The laptop does not have a serial port,
 so I can't capture the dmesg output.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

