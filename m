Return-Path: <linux-kernel-owner+w=401wt.eu-S1030766AbXDPPuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030766AbXDPPuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 11:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030781AbXDPPuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 11:50:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:54995 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030780AbXDPPuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 11:50:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Md8FAp7eS3xRyEILsIceYSm6amPSKbGkQfMkXhAKEckITub48ilCURs/jCfwY8zwmQNMFZZvLpVkEOJt9rNlFDPrtREVr5w790QrRIyl/LzFBYzwXkPOQzvIxhaauFdE1W9K1bSpxBkKnHAvX9kp8qIsBlcsfJ4fKFKN9AsTLdY=
Message-ID: <d120d5000704160850m7c08debam9b0869cbb19cc593@mail.gmail.com>
Date: Mon, 16 Apr 2007 11:50:12 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [GIT PATCHES] V4L/DVB updates
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1176653207.10849.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1176653207.10849.5.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On 4/15/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
>   - Fix Kernel Bugzilla #8301: spinlock fix for flexcop-pci

While move of spin_lock_init before request_irq is obviously correct I
wonder what is the reason behind changing spin_lock_irq() into
spin_lock_irqsave() as I do not see flexcop_pci_isr being called from
anywhere but IRQ context.

BTW, is irq_lock needed at all?

-- 
Dmitry
