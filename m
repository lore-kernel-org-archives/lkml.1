Return-Path: <linux-kernel-owner+w=401wt.eu-S1761290AbYEANIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbYEANIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757567AbYEANIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:08:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:59456 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952AbYEANIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:08:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O914CH6/ATGSnYIyaaZDPNf09FI4yVsxDm2KbA1/2/bNo1EMdFsEX+MbtYsflLyaD8QAJPYslHlfKAJrHjwM928C6j/KuT3m4qHlBlpKWrI62hPd41UqcXqIBxnKQsc2noQMISBi0+da0WJ/v5WPsEwcMO9JxDtdA6tsROfxu44=
Message-ID: <a44ae5cd0805010608n6c441082udd00c315e786de40@mail.gmail.com>
Date: Thu, 1 May 2008 09:08:18 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.25-git16 -- BUG: unable to handle kernel NULL pointer dereference at 00000000 -- IP: [<c02dd5d5>] fw_show_drv_device_ids+0xd9/0xee
Cc: linux-kernel@vger.kernel.org, "Kristian Hoegsberg" <krh@redhat.com>,
       linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.39b6a8e0dced1929@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0804301729q77530ecerdbb65b4ed40eeba@mail.gmail.com>
	 <tkrat.39b6a8e0dced1929@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan.  Thanks for your patch.  It worked great.  Now I see this
in the logs:

ohci1394: fw-host0: SelfID received outside of bus reset sequence
IEEE 1394 device has ROM CRC error
IEEE 1394 device has ROM CRC error
Program usplash tried to access /dev/mem between 0->8000000.
ieee1394: Node added: ID:BUS[0-00:1023]  GUID[00d0f54000000173]
ieee1394: Host added: ID:BUS[0-01:1023]  GUID[00e018000027d06c]
IEEE 1394 device has ROM CRC error
IEEE 1394 device has ROM CRC error
IEEE 1394 device has ROM CRC error
IEEE 1394 device has ROM CRC error
IEEE 1394 device has ROM CRC error

Also, "cat /sys/bus/ieee1394/drivers/raw1394/device_ids" no longer
causes an error.

Is it necessary for the code to spit out so many CRC errors for the
OrangeMicro iBot?  Also, are these errors indicating a significant
problem with the iBot?

Cheers,
     Miles
