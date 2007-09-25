Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbXIYRTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbXIYRTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbXIYRTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:19:25 -0400
Received: from h90-m1.hosting90.cz ([81.0.225.70]:50161 "EHLO
	h90-m1.hosting90.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbXIYRTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:19:24 -0400
Message-ID: <46F9431C.6020202@prepere.com>
Date: Tue, 25 Sep 2007 19:19:24 +0200
From: Miloslav Semler <majkls@prepere.com>
User-Agent: IceDove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Jan Engelhardt <jengelh@computergmbh.de>, serge@hallyn.com,
       davidsen@tmr.com, philipp@marek.priv.at, 7eggert@gmx.de,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
References: <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <Pine.LNX.4.64.0709251715390.945@fbirervta.pbzchgretzou.qr> <46F92C17.3060405@davidnewall.com> <Pine.LNX.4.64.0709251748240.945@fbirervta.pbzchgretzou.qr> <46F9351D.8020906@prepere.com> <Pine.LNX.4.64.0709251847570.945@fbirervta.pbzchgretzou.qr> <46F93EAF.20706@prepere.com> <Pine.LNX.4.64.0709251903480.945@fbirervta.pbzchgretzou.qr> <20070925170933.GJ8181@ftp.linux.org.uk>
In-Reply-To: <20070925170933.GJ8181@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, Sep 25, 2007 at 07:05:06PM +0200, Jan Engelhardt wrote:
>
>   
>> Perhaps that was formulated a bit sloppy. It of course means
>> "On chroot(2), implicitly close all FDs that point outside."
>>     
>
> Bollocks.  Pack 'em into SCM_RIGHTS datagram, send to yourself,
> do chroot, recvmsg() and move on, cheerfully spitting at the
> YAidiotic "hardening".
>   
so if you check sanity in fchdir (if directory_is_out), your method will 
not succeed :)
