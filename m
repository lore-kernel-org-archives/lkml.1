Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbXLQNdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbXLQNdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbXLQNd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:33:27 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:52329 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbXLQNd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:33:26 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18IgTayfmpFmSdi63peyzl2
Message-ID: <47667A85.3080100@reed.com>
Date: Mon, 17 Dec 2007 08:32:53 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Rolland <rol@as2917.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <20071217105744.GA14315@elte.hu> <4766684D.40202@gmail.com> <20071217130933.GB27992@elte.hu> <47667812.8050708@gmail.com>
In-Reply-To: <47667812.8050708@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> No, most definitely not. Having the user select udelay or none through 
> the kernel config and then the kernel deciding "ah, you know what, 
> I'll know better and use port access anyway" is _utterly_ broken 
> behaviour. Software needs to listen to its master.
>
When acting as an ordinary user, the .config is beyond my control 
(except on Gentoo).   It is in control of the distro (Fedora, Ubuntu, 
... but perhaps not Gentoo).  I think the distro guys want a default 
behavior that is set in .config, with quirk overrides being done when 
needed.   And of course the user in his/her boot params gets the final say.
