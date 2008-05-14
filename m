Return-Path: <linux-kernel-owner+w=401wt.eu-S1763461AbYENSxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763461AbYENSxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 14:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYENSxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 14:53:12 -0400
Received: from mx0.towertech.it ([213.215.222.73]:40710 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752168AbYENSxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 14:53:11 -0400
Date: Wed, 14 May 2008 20:53:08 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: Kim.Heino@bluegiga.com, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [PATCH] add support for ST M41T94 SPI RTC
Message-ID: <20080514205308.63951ad0@i1501.lan.towertech.it>
In-Reply-To: <482AF5E7.9070801@bluegiga.com>
References: <482AD8D9.4090805@bluegiga.com>
	<20080514150820.7eb523c6@i1501.lan.towertech.it>
	<482AF5E7.9070801@bluegiga.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 17:23:35 +0300
"Kim B. Heino" <Kim.Heino@bluegiga.com> wrote:

>
> 
> >> +struct m41t94 {
> >> +	struct rtc_device *rtc;
> >> +	u8 buf[8]; /* Burst read cmd + 7 registers */
> >> +};
> >  why are you keeping the buffer here?
> 
> rtc-max6902.c did that too... Fixed.

 d'oh! I missed it. :)
 
> >  the choice is up to you, but I'd use the century bit if there
> >  is one.
> 
> Ok, I'll add support for century bit. Again there are some other 
> rtc-drivers (like rtc-m41t80.c and rtc-ds1307.c) not using it.

 it's not mandatory, just a suggestion.

> 
> I'll wait for more comments and post a new patch tomorrow.

 ok, thanks.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

