Return-Path: <linux-kernel-owner+w=401wt.eu-S934764AbZKYNgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934764AbZKYNgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934724AbZKYNgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:36:35 -0500
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:33029 "EHLO
	elettra.colt-to.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934748AbZKYNga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:36:30 -0500
Date: Wed, 25 Nov 2009 14:36:34 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: specter118@gmail.com, Wan ZongShun <mcuos.com@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [rtc-linux] Re: [PATCH V3] ARM: NUC900: add RTC driver support
 for  nuc910 and nuc920
Message-ID: <20091125143634.1b8e0839@linux.lan.towertech.it>
In-Reply-To: <713d0d430911250451x51e0196bwdcbe5e8f087c3f8c@mail.gmail.com>
References: <4B0D1FFB.5060403@gmail.com>
	<713d0d430911250451x51e0196bwdcbe5e8f087c3f8c@mail.gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 20:51:24 +0800
Hu Ruihuan <specter118@gmail.com> wrote:

> I think you should lock irq before the serial read and write to the
> REG_RTC_RIER register.

 the lock seems not used anymore. the rtc framework has some locking
 of his own, driver authors are suggested to check if it's enough.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

