Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbYD2Mvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbYD2Mvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYD2Mvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:51:40 -0400
Received: from mx0.towertech.it ([213.215.222.73]:48974 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751631AbYD2Mvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:51:39 -0400
Date: Tue, 29 Apr 2008 14:51:35 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: rtc: how should I handle an invalid state?
Message-ID: <20080429145135.26d53758@i1501.lan.towertech.it>
In-Reply-To: <20080429121924.GA2137@digi.com>
References: <20080429121924.GA2137@digi.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 14:19:24 +0200
Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com> wrote:

> Hello,
> 
> I'm still stuck with my rtc.  My current problem is setting the rtc
> using hwclock --systohc.
> 
> The problem is that hwclock tries to read the current time before
> setting the new one.  And if that fails, it doesn't update the rtc.

 That's a bug of hwclock. :( The correct behaviour for a driver
 is to return an error if the clock cannot be read.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

