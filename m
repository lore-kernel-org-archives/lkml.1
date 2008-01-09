Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYAIOM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYAIOM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 09:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYAIOMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 09:12:19 -0500
Received: from twin.jikos.cz ([213.151.79.26]:55242 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbYAIOMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 09:12:18 -0500
Date: Wed, 9 Jan 2008 15:12:11 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: "Adolfo R. Brandes" <arbrandes@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB HID: Missing keys on Gyration Media Center Universal Remote
 Control
In-Reply-To: <b4292e150712280848h36a5bbf5k76e121168e8bfd12@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801091509280.25041@twin.jikos.cz>
References: <b4292e150712280848h36a5bbf5k76e121168e8bfd12@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2007, Adolfo R. Brandes wrote:

>   It is a 2.4 Ghz RF remote, and its receiver connects via USB to the
> computer, registering two devices, a keyboard and a mouse.  From
> /proc/bus/input/devices:
> I: Bus=0003 Vendor=0c16 Product=0002 Version=0110
> N: Name="Gyration Gyration RF Technology Receiver"
> 1) The power button, which is actually a Sleep or Suspend button, when
> pressed repeats endlessly.  One must disconnect the receiver for it to
> stop.  I suspect this is because the key press event registers
> correctly, but not the key release.
> 2) Four of the buttons ("TV", "SETUP MENU", "LAST", and "INPUT") are
> not recognized and do not register any events.
>   I generated a log using a 2.6.24-rc6 kernel with
> CONFIG_HID_DEBUG=yes and evbug loaded, and saw that:
> * "SETUP MENU", "LAST", and "INPUT" keys do absolutely nothing.
> * "TV" registers something, but apparently not enough for an event.
> * "Power" correctly registers a Sleep event, but repeats endlessly.

Hi Adolfo,

thanks a lot for the detailed and accurate report. Yes, this device would 
require a mapping quirk for the non-working keys. The endlessly repeating 
key might need something more sophisticated. I will look into your report 
and send you a patch to test in a few days. Currently, I am overloaded 
with other things, sorry.

Thanks,

-- 
Jiri Kosina
