Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbYDYVoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbYDYVoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 17:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759286AbYDYVny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 17:43:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:16276 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbYDYVnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 17:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=MXsfag0+FC4DpFsCG/ZPv0nVqZ0VZcPHzheRcCNkU+1BAOv5NplfhDP8AdYldrUdMErKA9hvH7/ZSYoBr68kg59mWb/9ZgK1Nh7Tw49rP4sDQNoPG7Chp4L66SNR6U5NrLQjFMIcuPk2kCwJouvfWQoC9/EzvTAgIcs8bm5ChNs=
Message-ID: <48125094.9070007@gmail.com>
Date: Fri, 25 Apr 2008 23:43:48 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: post-2.6.25 locks up hard without any message
References: <20080425175423.4bfd1c7b@mjolnir.drzeus.cx>
In-Reply-To: <20080425175423.4bfd1c7b@mjolnir.drzeus.cx>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2008 05:54 PM, Pierre Ossman wrote:
> Something that was merged this window has made my life a bit difficult.
> My machine (a Thinkpad R61) locks up hard after a few minutes. There is
> no output on the console and no blinking keyboard leds, so it doesn't
> look like it's a panic.

So, are you able to grab console output, e.g. on netconsole? Does sysrq keys 
work in such a situation?

> My current HEAD is v2.6.25-3530-g94bc891 but I saw it in
> v2.6.25-2519-g3925e6f as well.
> 
> Any ideas or is it time for everyone's favourite git tool?

Well, if it is easily reproducible, then it's one of options to do a bisection.
