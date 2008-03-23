Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbYCWQy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbYCWQy4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 12:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYCWQyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 12:54:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38908 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYCWQyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:54:49 -0400
Message-ID: <47E68B50.7060503@zytor.com>
Date: Sun, 23 Mar 2008 09:54:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "John T." <j.thomast@yahoo.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
References: <349800.20247.qm@web45701.mail.sp1.yahoo.com>
In-Reply-To: <349800.20247.qm@web45701.mail.sp1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John T. wrote:
> 
> That's because you are working in "meta sends ESC" mode.
> Although this is OK for most applications, for some it isn't.
> Thus there have always been two modes, "meta sends ESC"
> and "meta sets 8th bit". (toggled with setmetamode on the
> console)
> 
> Vim relies on "meta sets 8th bit". Unfortunatelly the code
> for this options does not work in UTF-8 in the console. What
> I'd like to do is make this a viable option in UTF-8.
> 

No, fix vim instead.

"Meta sets 8th bit" is so obviously and totally broken, since it maps 
onto real characters, and has been doing so for at least 20 years. 
Meta-L maps onto LATIN CAPITAL LETTER I WITH GRAVE, both in 8-bit mode 
and in your proposed UTF-8 mode.  It just becomes even more obvious how 
unbelievably broken it is when you try to map it onto UTF-8.

Seriously, fix the crap.

	-hpa
