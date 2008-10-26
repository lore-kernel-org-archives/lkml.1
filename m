Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYJZAjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYJZAjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 20:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYJZAjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 20:39:08 -0400
Received: from twin.jikos.cz ([213.151.79.26]:60378 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYJZAjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 20:39:07 -0400
Date: Sun, 26 Oct 2008 02:39:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Mikko C." <mikko.cal@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Random problems with 2.6.28-rc1-git1
In-Reply-To: <490332E5.3020108@gmail.com>
Message-ID: <Pine.LNX.4.64.0810260235490.22126@twin.jikos.cz>
References: <490332E5.3020108@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008, Mikko C. wrote:

> Today I tried upgrading to 2.6.28-rc1-git1 (-rc1 couldn't even mount the 
> disk). I'm having some problems with it :)
> 1) Whenever I try to unload (rmmod or modprobe -r) *any* modules (even 
>    if not used), the system hangs.  I can still move the mouse and see 
>    the cursor moving, but I can't type, can't switch console, nothing.  
>    Because of this, I can't shutdown the system properly because it 
>    hangs when "Unloading ALSA modules"

If rmmod never returns, alt-sysrq-t output should show us where it got 
stuck.

> 2) Sometimes (randomly it seems) the system doesn't detect any usb 
>    devices:  I have an external HD and a Logitech mouse. Sometimes they 
>    are recognized, sometimes not.  Unplugging and re-plugging them 
>    doesn't help. lsusb shows no attached device.

Compiling with CONFIG_USB_DEBUG and sending report to 
linux-usb@vger.kernel.org with the output included might be a good start.

-- 
Jiri Kosina
SUSE Labs

