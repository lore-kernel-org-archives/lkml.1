Return-Path: <linux-kernel-owner+w=401wt.eu-S1762776AbXJMTcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762776AbXJMTcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 15:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbXJMTcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 15:32:07 -0400
Received: from ns01.unsolicited.net ([69.10.132.115]:53967 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbXJMTcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 15:32:06 -0400
X-Greylist: delayed 1887 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Oct 2007 15:32:06 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=simple; s=one; d=unsolicited.net;
	h=Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:Content-Type:Content-Transfer-Encoding;
	b=dATsrMgDyZsjhPMyIa6ja1s7JGw/Xp6Hs5u7lXXzhPRsWI2OeKJb9dO7x/CDKcadkTve4EpLIIDcoyyZXSiCR2rzJr/wgmnPEcjA2MTLdkF6gy4vWIQyYhjjLEtcfWS3VvcRGqHiwhGDh/Zh5qfQYGBjWEUEeSeEWJAeeyxrrbw=;
Message-ID: <4711159D.1010305@unsolicited.net>
Date: Sat, 13 Oct 2007 19:59:41 +0100
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Peter Volkov <pva@gentoo.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: regression(?): starting with 2.6.21 sending packets became broken.
References: <1192299385.31908.8.camel@localhost>
In-Reply-To: <1192299385.31908.8.camel@localhost>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Volkov wrote:
> Hello, all on the list.
>
> Please CC me in answers, I'm not subscribed. Please, if this is wrong
> list tell me what is correct.
>
> Starting with 2.6.21 (or may be 2.6.20 as I have not tried it) kernel I
> have problem that most tcp based services freeze at some point of
> operation. I've noticed this first on ssh but then found out that at
> lease one other service became similarly. The problem sites somewhere in
> the kernel as I've compiled 2.6.19, 2.6.21, and 2.6.22 with the
> similar .config options (of course not exact, as some options does not
> exist in some kernels, but seems that enabled options are all the same)
> but I have this problem only with the 21 and 22. I've tried to debug the
> problem a bit, but not a lot as that is production box working as linux
> based firewall/router.
>   
Try

echo 0 > /proc/sys/net/ipv4/tcp_window_scaling

I bet you have broken router(s) between your machine and the problem
site(s).

Cheers
David
