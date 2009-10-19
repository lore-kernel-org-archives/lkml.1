Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZJSKDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZJSKDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 06:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZJSKDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 06:03:30 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:52648 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZJSKD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 06:03:29 -0400
Message-ID: <4ADC3969.1010101@wpkg.org>
Date: Mon, 19 Oct 2009 12:03:21 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20091009)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: 2.6.31.4: WARNING: at drivers/usb/serial/usb-serial.c:446 serial_unthrottle
References: <4AD71FA3.8080801@wpkg.org> <20091015160501.36a31973@lxorguk.ukuu.org.uk>
In-Reply-To: <20091015160501.36a31973@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Thu, 15 Oct 2009 15:12:03 +0200
> Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> 
>> I see my minicom segfaulted for some reason (probably as I closed konsole window without exiting minicom first).
>>
>> And I see this warning in dmesg - anything useful?
> 
> Looks like a very very old bug in the tty code. I have a patch for this I'm
> testing for a while and will sort out properly after the kernel summit. In
> the mean time have a play with the patch below which ought to do the trick.

Since I'm not able to trigger this issue any more (even without this 
patch), I won't be able to tell if this patch changed anything or not.

Could be good or not, depending on how you look at it...


-- 
Tomasz Chmielewski
http://wpkg.org
