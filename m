Return-Path: <linux-kernel-owner+w=401wt.eu-S933583AbXEEQ6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583AbXEEQ6r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933587AbXEEQ6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:58:47 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:40294 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933583AbXEEQ6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:58:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EW/EqOisVDsJ2EnJnm1/ij9nbmAwBPKEYSZfw41NxV+YUxP7a+tbQ7sW8ivYDPdiuqqBHjNWVj+jCcUDB+1G63DpaL0CYSfpYCU9fe/a7g7Artf1hwX4XDcuLx2OBWgSIssMlFyKOrOK/pS/kqEYDBksWzQ18BlNPtmhfUTF5Uw=
Message-ID: <5486cca80705050958g397db6fepbe1e62b7e190a3f@mail.gmail.com>
Date: Sat, 5 May 2007 18:58:45 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Paul Fulghum" <paulkf@microgate.com>
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <5486cca80705050926j5c33eaf3m8723b76d4759fc5a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <1178308173.3743.14.camel@amdx2.microgate.com>
	 <5486cca80705041421y4fcaec01l7acafed1cea4b509@mail.gmail.com>
	 <463BC223.2040304@microgate.com> <1178353618.3472.1.camel@x2>
	 <5486cca80705050811k2903710y2bf9054434d8da4b@mail.gmail.com>
	 <463CB429.6050201@microgate.com> <1178381287.3379.8.camel@x2>
	 <1178381739.3379.11.camel@x2>
	 <5486cca80705050926j5c33eaf3m8723b76d4759fc5a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/5, Antonino Ingargiola <tritemio@gmail.com>:
> 2007/5/5, Paul Fulghum <paulkf@microgate.com>:
> > On Sat, 2007-05-05 at 11:08 -0500, Paul Fulghum wrote:
> > > I would argue that cdc-acm should do the same as the serial driver.
> >
> > Try this patch for the usb ports. (I don't have that hardware)
>
> Building... thanks.
>

This patch does not solve the problem with the cdc_acd driver. I still
need to flush two times to really flush the input. And the "secondary
buffer" still seems 26 bytes (as before).

Regards,

  ~ Antonio
