Return-Path: <linux-kernel-owner+w=401wt.eu-S935111AbXEIEbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935111AbXEIEbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 00:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935014AbXEIEbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 00:31:32 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:42136 "EHLO
	asav09.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935011AbXEIEbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 00:31:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuE6ADXqQEZKhRO4W2dsb2JhbACBXI4VHQ0FEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Jan Kratochvil <honza@jikos.cz>
Subject: Re: [PATCH 3/3] xpad.c: Added Xbox360 gamepad rumble support.
Date: Wed, 9 May 2007 00:31:28 -0400
User-Agent: KMail/1.9.3
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
References: <Pine.LNX.4.64.0705021704180.13550@twin.jikos.cz> <alpine.LRH.0.98.0705031504280.22353@twin.jikos.cz> <alpine.LRH.0.98.0705032326440.22353@twin.jikos.cz>
In-Reply-To: <alpine.LRH.0.98.0705032326440.22353@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705090031.29817.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Thursday 03 May 2007 17:41, Jan Kratochvil wrote:
> Hi again,
>    what do you think about this? (This patch will work only against last 
> gamepad rumble support patch)
> 
> Thanks for your time
>  	Jan Kratochvil
> 
> BigX button on xbox360 gamepad is surrounded by 4 green leds. This
> patch adds support to control them.
> 
> This device understand to 14 messages (described at 
> http://www.free60.org/wiki/Gamepad#LED_Control).
> 
> Control is done through event interface, message type EV_LED. EV_LED isn't 
> perfect match because you are actualy not turning some led on or off but 
> more likely you are telling the gamepad what "flash effect" it should 
> play.
> 

I would rather it used led subsystem for this.

-- 
Dmitry
