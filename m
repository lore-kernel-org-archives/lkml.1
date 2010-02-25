Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165Ab0BYRwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:52:51 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:42111 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933139Ab0BYRws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:52:48 -0500
Message-ID: <d8539fd26220388f501300c92b12bbe1.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <20100225123214.0523a310@neptune.home>
References: <20100221002001.0a7e05a7@neptune.home>
    <20100224170049.0d04af3c@neptune.home>
    <alpine.LNX.2.00.1002251201430.30967@pobox.suse.cz>
    <20100225123214.0523a310@neptune.home>
Date: Thu, 25 Feb 2010 10:52:40 -0700
Subject: Re: [PATCH 1/3] picolcd: driver for PicoLCD HID device
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: Bruno =?iso-8859-1?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: "Jiri Kosina" <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Nicu Pavel" <npavel@ituner.com>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bruno Prémont wrote:
> The one for deferredio refresh rate should ideally go below fb device
> (and I guess that might also be of use for other users of deferredio)
>

I'm testing a patch now. I didn't expect anyone else would really need it,
but it does help with throttling bus traffic from userspace.

If it's in fbsysfs.c we can both eliminate it from our drivers.

-- 

Rick

