Return-Path: <linux-kernel-owner+w=401wt.eu-S1751845AbXCHNnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbXCHNnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 08:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbXCHNnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 08:43:35 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:7803 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbXCHNne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 08:43:34 -0500
X-IronPort-AV: i="4.14,264,1170651600"; 
   d="scan'208"; a="23902653:sNHT52241063"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Oleksiy Kebkal" <kebkal@gmail.com>
Subject: Re: should RTS init in serial core be tied to CRTSCTS
Date: Thu, 8 Mar 2007 08:44:31 -0500
User-Agent: KMail/1.9.5
Cc: "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Mike Frysinger" <vapier.adi@gmail.com>, rmk@arm.linux.org.uk,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com> <200703071019.55896.rgetz@blackfin.uclinux.org> <57354eff0703071330k2395e9c8n58e12f2111dcb25a@mail.gmail.com>
In-Reply-To: <57354eff0703071330k2395e9c8n58e12f2111dcb25a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703080844.32157.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 08 Mar 2007 13:43:31.0990 (UTC) FILETIME=[C2CAD360:01C76187]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 7 Mar 2007 16:30, Oleksiy Kebkal pondered:
> 2007/3/7, Robin Getz <rgetz@blackfin.uclinux.org>:
> > Right - so the question is where to manage the default state? I was
> > thinking in the resource might be a good idea, but there isn't really a
> > good place for it. (You could re-use some bits if flags, but I think that
> > would not be a good idea).
>
> /proc/tty/driver/uartN/settings?
>

That would let you change things are run time, but the problem is at boot 
time. A default setting needs to be set, so when things initialize, and proc 
does not exist yet, it is still set properly...

-Robin
