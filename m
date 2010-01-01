Return-Path: <linux-kernel-owner+w=401wt.eu-S1751662Ab0AANkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab0AANkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 08:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500Ab0AANkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 08:40:42 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:18117 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab0AANkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 08:40:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cNupm4xlPvGuA2jMI/th8uLBy22JFp43dHxg8j9YCtIL3ScRnzgRWtP+ZTvzDmTTCQ
         UQa8Bm7Xw7ig3KEP3vs1FYbl+qEDIJv9S6G6rS3MdeY0qzWVpWZGKwoHODCPCcRAAQ6E
         2gbTMrO8oj3Q9ap1QOs04mGICpuaVqtV2YLAw=
MIME-Version: 1.0
In-Reply-To: <4B2FEE46.5030700@unsolicited.net>
References: <4B2FEE46.5030700@unsolicited.net>
Date: Fri, 1 Jan 2010 14:40:38 +0100
Message-ID: <8db1092f1001010540l15c8f671y1f6a4a4417eb450b@mail.gmail.com>
Subject: Re: 2.6.33-rc1 - Weird hard hangs when rendering 'some' web-sites in 
	Firefox
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: David <david@unsolicited.net>
Cc: linux-kernel@vger.kernel.org,
       Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/21 David <david@unsolicited.net>:
> I'm still not sure whether what I'm seeing here is latent hardware
> problems, but, as a heads up :-
>
>    2.6.32, 2.6.32.2 (and previous kernels) - All OK
>    2.6.33-rc1 - Machine seems fine, until :-
>
> I browse to particular sites (one of which is an internet banking site,
> so no heavy flash etc.). My machine will (completely and repeatably)
> hang solid. Nothing showing with netconsole, sshd dead, sysrq dead ...
> reset button time.
>
> .config, bootup dmesg, and lspci -vvv attached for interest (userspace
> is Ubuntu 9.10).
>
> May have time to bisect, but not 'till the holidays.
>
> Cheers
> David
>
>

I can confirm this. Probably it's related only to wireless
connections, wired seems be OK. My device is:
08:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
[Golan] Network Connection (rev 02)

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
