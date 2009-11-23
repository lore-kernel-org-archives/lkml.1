Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbZKWIVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbZKWIVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 03:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbZKWIVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 03:21:38 -0500
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:57547 "EHLO
	elettra.colt-to.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752588AbZKWIVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 03:21:37 -0500
Date: Mon, 23 Nov 2009 09:21:41 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: rtc-linux@googlegroups.com, Paul Gortmaker <p_gortmaker@yahoo.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [rtc-linux] [PATCH] ARM: NUC900: add rtc controller driver
 support  for NUC900
Message-ID: <20091123092141.519d0ec1@linux.lan.towertech.it>
In-Reply-To: <4B0A2D31.5020307@gmail.com>
References: <4B097FA0.8040308@gmail.com>
	<20091122214107.1a0c4e72@linux.lan.towertech.it>
	<4B0A2D31.5020307@gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009 14:35:29 +0800
Wan ZongShun <mcuos.com@gmail.com> wrote:

> Thanks a lot for your advice, and I have fixed my patch.
> But, I have a question ,which is that why do not implement ops->ioctl()
> unless absolutely necessary? and I see many other rtc driver have implemented it. 

 That's because the RTC framework will provide one
 for you if you define the irq functions in your 
 rtc_ops. check *_irq_enable, irq_set_state, irq_set_freq.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

