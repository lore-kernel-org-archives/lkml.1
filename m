Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbZFVN73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbZFVN73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZFVN7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:59:04 -0400
Received: from dan.rpsys.net ([93.97.175.187]:58342 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbZFVN7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:59:03 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jun 2009 09:59:02 EDT
Subject: Re: 2.6.30: hald crashes on resume from STR apparently on LED
	device
From: Richard Purdie <rpurdie@rpsys.net>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: hal@lists.freedesktop.org, linux-kernel@vger.kernel.org
In-Reply-To: <200906211817.25878.arvidjaar@mail.ru>
References: <200906142219.06891.arvidjaar@mail.ru>
	 <200906211817.25878.arvidjaar@mail.ru>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 14:57:24 +0100
Message-Id: <1245679044.10200.17.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-21 at 18:17 +0400, Andrey Borzenkov wrote:
> So what happens is simple. During suspend led device is removed; during 
> resume it is recreated. Apparently removing led device cause hald-addon-
> leds to exit (thus disconnecting D-Bus connection); and sometimes next 
> "add" event comes too early, before hald had chance to notice missing 
> addon.

Note that its the underlying device that is being removed here and since
the LED is connected to that its removed as well. The LED subsystem
hasn't changed in how it works. I don't think that has any bearing on
your patch though.

Regards,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

