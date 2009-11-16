Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbZKPLQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbZKPLQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 06:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZKPLQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 06:16:50 -0500
Received: from csldevices.co.uk ([77.75.105.137]:38251 "EHLO
	mhall.vps.goscomb.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752194AbZKPLQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 06:16:50 -0500
Message-ID: <4B01349D.3010809@csldevices.co.uk>
Date: Mon, 16 Nov 2009 11:16:45 +0000
From: Philip Downer <phil@csldevices.co.uk>
User-Agent: Icedove 1.5.0.14eol (X11/20090105)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Robert Hancock <hancockrwd@gmail.com>, venu <vjosyula@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: firmware loading interface
References: <4AFD971C.3090204@csldevices.co.uk>	<4AFD9BAF.1010200@csldevices.co.uk>	<aday6mac5ai.fsf@roland-alpha.cisco.com>	<4AFED614.1050109@gmail.com>	<53ea87da0911140855u7993989aod746bcaf18ee4c31@mail.gmail.com>	<51f3faa70911141019y1248fb27k5f7edb3729f72375@mail.gmail.com> <20091114102919.54606831@infradead.org>
In-Reply-To: <20091114102919.54606831@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> it's not unusual to have a sysfs attribute that, when written to, will
> just do a request_firmware().
> It's not pretty, but it's cleaner than the alternatives....
>   

This was in fact what I was considering when making my initial post, but 
couldn't find any examples or drivers which do use sysfs and request 
firmware in this way and as you say, it's not pretty. However if it's 
considered to be cleaner by others (I certainly think it to be so) then 
I am inclined to use this method as opposed to the ioctl method 
suggested by Arnd earlier in the thread.

Arjan, could you possibly point me at any drivers which already work in 
this way?

Thanks,

Philip Downer

