Return-Path: <linux-kernel-owner+w=401wt.eu-S934249AbXEESIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249AbXEESIK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934253AbXEESIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:08:10 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:20319 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934249AbXEESIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:08:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kthl8sE/uvJx7XSJ4lm49pX1G7MlI0aVk5Xhy49tSYUbJ5IObD/QlVQiNQ218jkHziCLKQZPMxY+dsHjT/lVmqqnvpSDo53OT2wG9c4EQ9KNxn5vrJOOTQlr0tqzbpCU7haHsg2piOyJfpJU8ZD7uJF9dJ2ccpaBZ0CoKKhjfSI=
Message-ID: <5486cca80705051108p55b2cddfydce54aa15dd317f4@mail.gmail.com>
Date: Sat, 5 May 2007 20:08:05 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Paul Fulghum" <paulkf@microgate.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Oliver Neukum" <oliver@neukum.org>
In-Reply-To: <1178384675.3379.26.camel@x2>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <463BC223.2040304@microgate.com> <1178353618.3472.1.camel@x2>
	 <5486cca80705050811k2903710y2bf9054434d8da4b@mail.gmail.com>
	 <463CB429.6050201@microgate.com> <1178381287.3379.8.camel@x2>
	 <1178381739.3379.11.camel@x2>
	 <5486cca80705050926j5c33eaf3m8723b76d4759fc5a@mail.gmail.com>
	 <5486cca80705050958g397db6fepbe1e62b7e190a3f@mail.gmail.com>
	 <1178384675.3379.26.camel@x2>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/5, Paul Fulghum <paulkf@microgate.com>:
> On Sat, 2007-05-05 at 18:58 +0200, Antonino Ingargiola wrote:
> > This patch does not solve the problem with the cdc_acd driver. I still
> > need to flush two times to really flush the input. And the "secondary
> > buffer" still seems 26 bytes (as before).
>
> I missed a bit, try this.
>

Tried and this one work right. A single flush is sufficient to
completely flush the input buffer. Again, thanks a lot :).

Now I don't want to abuse your kindness, but I (personally) would be
*really* interested in a similar fix for the FTDI usb-serial driver,
because many measurements I do use an FTDI device.

However, if I understood well seems that many drives have to be
checked against this problem.


Regards,

  ~ Antonio
