Return-Path: <linux-kernel-owner+w=401wt.eu-S932652AbXC0QEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbXC0QEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932837AbXC0QEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:04:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932652AbXC0QEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:04:52 -0400
Message-ID: <4609409F.2070203@redhat.com>
Date: Tue, 27 Mar 2007 12:04:47 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Pete Zaitcev <zaitcev@redhat.com>, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       Peter Osterlund <petero2@telia.com>
Subject: Re: Fix sudden warps in mousedev
References: <20070324001610.724a820a.zaitcev@redhat.com>	 <d120d5000703261230h1724e453je2c14769fc099ad3@mail.gmail.com>	 <20070326144206.93805eeb.zaitcev@redhat.com>	 <200703262114.45287.dtor@insightbb.com> <460934D7.9030700@redhat.com> <d120d5000703270846y87e4283m4009ff0a9f65dac4@mail.gmail.com>
In-Reply-To: <d120d5000703270846y87e4283m4009ff0a9f65dac4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
>>
>> And why did the mouse numbers all get rearranged in 2.6.20, e.g.
>> mouse1 became mouse2 for many people?
> 
> Input devices are not guaranteed to be stable.
> 

So people with z-axis mice need to redo their X config for each
kernel release when the device numbers change? Or should they
be using some other configuration?

People using this now have X crashes on kernel upgrade because
event1 became event2:

        Driver      "evdev"
        Option      "Device" "/dev/input/event1"

