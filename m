Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbXCGPTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbXCGPTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbXCGPTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:19:04 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:4703 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbXCGPTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:19:03 -0500
X-IronPort-AV: i="4.14,260,1170651600"; 
   d="scan'208"; a="23803696:sNHT23746345"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: should RTS init in serial core be tied to CRTSCTS
Date: Wed, 7 Mar 2007 10:19:55 -0500
User-Agent: KMail/1.9.5
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, rmk@arm.linux.org.uk,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com> <200703061824.08834.rgetz@blackfin.uclinux.org> <m3irddusp0.fsf@maximus.localdomain>
In-Reply-To: <m3irddusp0.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703071019.55896.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 07 Mar 2007 15:18:56.0498 (UTC) FILETIME=[EC73AD20:01C760CB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 7 Mar 2007 07:46, Krzysztof Halasa pondered:
> Robin Getz <rgetz@blackfin.uclinux.org> writes:
> > It is useful on (broken) legacy serial equipment, where RTS should be
> > completely under the applications control.
> >
> > Glitches on RTS aren't acceptable, and confuse some devices.
>
> Does that mean you can't use TIOCMSET, TIOCM_RTS etc?
>
> > I understand - the request wasn't to change the default operation -
>
> just
>
> > add a
> > method of controlling things, so those minority of people who want the
> >
> > control can have it.
>
> No problem as long as open without CRTSCTS raises RTS by default.

Right - so the question is where to manage the default state? I was thinking 
in the resource might be a good idea, but there isn't really a good place for 
it. (You could re-use some bits if flags, but I think that would not be a 
good idea).

-Robin
