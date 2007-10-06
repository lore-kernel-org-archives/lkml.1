Return-Path: <linux-kernel-owner+w=401wt.eu-S1762499AbXJFKDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762499AbXJFKDE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 06:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbXJFKCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 06:02:54 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36992 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbXJFKCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 06:02:54 -0400
Date: Sat, 6 Oct 2007 12:02:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [PATCH] vc bell config
In-Reply-To: <20071006105536.1a237390@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0710061200030.5969@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710051347000.13406@fbirervta.pbzchgretzou.qr>
 <20071005170011.b4d280bf.akpm@linux-foundation.org> <20071006105536.1a237390@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 6 2007 10:55, Alan Cox wrote:
>> > 
>> > It is already possible to deactivate the vc bell on a per-tty basis,
>> > by using echo -en "\e[11;0]", but this is reset on reset(1).
>> > 
>> > This adds a sysfs parameter to globally control the vc bell, as well
>> > as sysfs parameters for default pitch and duration.
>> 
>man setterm
>
>See -blength and -bfreq

Only sets length and freq of current tty, and only until `reset`.
It's equivalent to \e[10;x] and \e[11;x].
