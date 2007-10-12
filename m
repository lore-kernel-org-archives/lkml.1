Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbXJLPkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbXJLPkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 11:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXJLPkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 11:40:00 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:47406 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbXJLPj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 11:39:58 -0400
X-IronPort-AV: i="4.21,267,1188792000"; 
   d="scan'208"; a="53874138:sNHT1406117251"
Subject: Re: [PATCH try #2] Input/Joystick Driver: add support AD7142
	joystick driver
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: bryan.wu@analog.com, linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <d120d5000710120749o2505dd7aq42559c35298f05d0@mail.gmail.com>
References: <1192174727.6247.20.camel@roc-laptop>
	 <d120d5000710120749o2505dd7aq42559c35298f05d0@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Fri, 12 Oct 2007 23:39:53 +0800
Message-Id: <1192203593.7089.4.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 12 Oct 2007 15:39:56.0653 (UTC) FILETIME=[240751D0:01C80CE6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-12 at 10:49 -0400, Dmitry Torokhov wrote:
> Hi Bryan,
> 
> On 10/12/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > +
[snip]
> > +
> > +static void ad7142_close(struct input_dev *dev)
> > +{
> > +       free_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX, ad7142_interrupt);
> > +       kthread_stop(ad7142_task);
> 
> Don't you need to write something over i2c to shut the devoce off?
> What stops it from continuing to generate interrupts?
> 
Actually, I am going to use "completion" to replace the whole
wait_interrupt_xxx and intr_flag things which original from Aubrey. How
do you think of that?

Thanks
-Bryan
