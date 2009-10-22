Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbZJVQKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbZJVQKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZJVQKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:10:53 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:26609 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbZJVQKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:10:52 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4AE0840C.8070801@tremplin-utc.net>
Date: Thu, 22 Oct 2009 18:10:52 +0200
From: =?ISO-8859-15?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not  work anymore
References: <928C125D-D36B-47C9-A549-3EE502C9EC73@gmail.com> <20091015215944.GA9845@core.coreip.homeip.net> <4ADF6237.9070004@tremplin-utc.net> <200910211320.16339.dmitry.torokhov@gmail.com>
In-Reply-To: <200910211320.16339.dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 21-10-09 22:20, Dmitry Torokhov schreef:
> 
> Nothing, as far as I can tell... I see you typing "qwerty"... Does the 
> keyboard work in console (let's say if you boot in run level 3 to take X out 
> of the picture)? Could you please try compiling evbug module - it will show if 
> keyboard events are propagated through input core. Also, whta driver are you 
> using in X? Legacy keyboard or evdev?
In the console (in init 3), I haven't managed to reproduce it. In xorg,
the keyboard input uses evdev. Now I've just tried "evtest
/dev/input/event4", when the keyboard doesn't work... and I see the key
presses!

So I guess it rules out a bug in the kernel, and I have to talk with the
people from Xorg, right?

Thanks,
Eric
