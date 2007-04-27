Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbXD0XYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbXD0XYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbXD0XYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:24:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:5614 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757902AbXD0XYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:24:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kswtb0Mam/lZw0V49t6g/tc6k71nvYV4N4ZGMVGXmnRzcMbFI9a12VnRYer6j/njze1tNkgzxpI2OGupL6b9z/QCTBsrjkEZDVKvggJ+fTrc0vEDcKD64fKrjIIgHKAFAXuJYcHI8KD9dlr8/xqz3frenXZKEgTMK+CsERlSdgw=
Message-ID: <d9def9db0704271624u2e895200jbe6986d913cf0e38@mail.gmail.com>
Date: Sat, 28 Apr 2007 01:24:45 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: More than 2Gb problem (dvb related) ?
Cc: "Gregoire Favre" <Gregoire.Favre@gmail.com>, linux-kernel@vger.kernel.org,
       linux-dvb@linuxtv.org
In-Reply-To: <46327F5D.4060708@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.pO/RoNmzgLz6KNMO4Ste8iezOk8@ifi.uio.no>
	 <46327F5D.4060708@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Does this only happen with DVB and not with analogue TV (I know there
are some cx88 hybrid devices out there, I recently got one but
couldn't tested it yet ..)?

Markus

On 4/28/07, Robert Hancock <hancockr@shaw.ca> wrote:
> Gregoire Favre wrote:
> > Hello,
> >
> > I have a computer (mother Asus Commando) with 4x1Gb Ram.
> >
> > If I start without the BIOS remap memory, my BIOS and linux just see 2Gb
> > of ram, and DVB apps works just great.
> >
> > When I enable the remapping of the memory, my BIOS and linux just see
> > the whole 4Gb but then, I can tune to any transponder without problem,
> > but I am unable to get a TS...
> >
> > I have tested it with vdr/kaffeine/mplayer.
> >
> > szap/kaffeine/vdr get the lock just well.
> >
> > I had already asked about this on just linux-dvb ml, but maybe I am the
> > first one to try DVB with a system with more than 2 Gb as I didn't
> > receive any further info as someone get it working or not with such
> > amount of ram.
> >
> > Anyone got an idea on what could be done to solve this issue ?
> >
> > PLEASE CC to me all message in lkml as I am not subscribed to this ml :)
>
> Sounds like the cx88 driver is not using the DMA API properly to set up
> proper mappings, this will blow up if it tries to access memory above
> the 4GB mark if the device cannot do >32bit DMA..
>
> --
> Robert Hancock      Saskatoon, SK, Canada
> To email, remove "nospam" from hancockr@nospamshaw.ca
> Home Page: http://www.roberthancock.com/
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Markus Rechberger
