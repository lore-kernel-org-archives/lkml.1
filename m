Return-Path: <linux-kernel-owner+w=401wt.eu-S1760319AbYB2MrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319AbYB2MrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 07:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYB2MrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 07:47:12 -0500
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:43474 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633AbYB2MrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:47:11 -0500
Message-ID: <47C7FECD.3040205@Keehan.net>
Date: Fri, 29 Feb 2008 12:47:09 +0000
From: Mike Keehan <Mike@Keehan.net>
Reply-To: Mike@Keehan.net
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Harald Dunkel <harald.dunkel@t-online.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: strange behavior on multimedia eject button for cdrom
References: <47C15020.8040806@t-online.de>
In-Reply-To: <47C15020.8040806@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harold.

Somewhere on the web I read that some of the M1330 media keys are 
directly connected to the drive, hence the lack of keycodes.

If you eject a disk while it is being played, then the Linux driver 
will get a read failure.  What happens then may not be well defined :)

Mike.


Harald Dunkel wrote:
> Hi folks,
> 
> My laptop (Dell XPS M1330) has some multimedia keys added to the
> keyboard, including an eject button for the cdrom drive, instead
> of a "regular" eject button built into the drive itself.
> 
> When I press it to eject a CD, then Linux becomes pretty mad: The
> audio device gets stuck somehow, playing the same tune over and
> over again, the network connection is frozen, etc. Once the CD is
> out it is back to normal, as it seems.
> 
> I would guess that the eject button triggers some bios functionality,
> outside of the control of the kernel. But is it? How comes that
> Linux seems to loose control in this case?
> 
> Kernel is 2.6.24.2 (amd64).
> 
> AFAICS this eject button has no keycode. The other multimedia keys
> have.
> 
> 
> Any helpful idea would be very welcome.
> 
> 
> Regards
> 
> Harri
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


