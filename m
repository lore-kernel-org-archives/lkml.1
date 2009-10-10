Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZJJILK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZJJILK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 04:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZJJILJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 04:11:09 -0400
Received: from 007.netroom.de ([194.0.247.207]:21841 "EHLO 007.netroom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbZJJILI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 04:11:08 -0400
X-Greylist: delayed 2064 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Oct 2009 04:11:08 EDT
Message-ID: <4AD03A03.5050702@draisberghof.de>
Date: Sat, 10 Oct 2009 09:38:43 +0200
From: Josua Dietze <digidietze@draisberghof.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Hugh Blemings <hugh@blemings.org>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2
References: <1255134315.2139.8.camel@pasglop>
In-Reply-To: <1255134315.2139.8.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt schrieb:


> The symptom is that the USB modem just disconnects/reconnects in a loop.
> The log looks like what I pasted below when plugging the device (and
> leaving it in, the disconnects don't correspond to the device being
> removed).


This is one of the mode switching devices. It is switched to modem 
mode by "usb_stor_huawei_e220_init".

Something keeps resetting it to initial mode. It might be a 
powersave/suspend issue.


Josua Dietze
-- 
Man is the only creature on earth enabled to take a
warm meal while flying!                      Loriot
