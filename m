Return-Path: <linux-kernel-owner+w=401wt.eu-S1756517AbZFAOga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbZFAOga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbZFAOgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:36:12 -0400
Received: from mx0.towertech.it ([213.215.222.73]:40097 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754327AbZFAOgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:36:11 -0400
Date: Mon, 1 Jun 2009 16:36:09 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: wizant.keidel@online.de
Cc: p_gortmaker@yahoo.com, linux-kernel@vger.kernel.org
Subject: Re: RTC-driver kernel 2.6.xxx missing Symbols
Message-ID: <20090601163609.096e4129@i1501.lan.towertech.it>
In-Reply-To: <4A23D43B.3030900@online.de>
References: <4A23D43B.3030900@online.de>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Jun 2009 15:14:35 +0200
Juergen Keidel <wizant.keidel@online.de> wrote:

> ello,
> The actual kernel has a new reworked rtc driving system. before, I think
> 2.6.5, the driver was rtc (rtc.c in drivers/char from  Paul Gortmaker,
> which exported the function rtc_control, rtc_register, rtc_unregister.
> These functions are very useful for drivers wich need acces to the rtc.
> The new rtc-system (rtc-cmos) is missing these functions.
> As I found out, some drivers especially within the sound area are using
> the functionality, so they won't load anymore!
> (sound/core/rtctimer.c)
> Is there a way around with the new system or is it planned to reactivate
> these functionality.

 There's an equivalent functionality which allows any in-kernel user to register
 and receive timing interrupts.

 That said, I think it would be better to use other timing sources.

 Except rtctimer.c, which other driver is using it? When I searched for it,
 rtctimer was the only user and I believe its usage is not widespread.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

