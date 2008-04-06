Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbYDFIqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbYDFIqn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 04:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYDFIqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 04:46:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:34495 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751141AbYDFIqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 04:46:34 -0400
X-Authenticated: #420190
X-Provags-ID: V01U2FsdGVkX18+7BsY59w+XP9vm/JboSc0sUqIAKVxaXauDJZRxr
	PC+qOxhGbglbAs
Message-ID: <47F88DDB.30409@gmx.net>
Date: Sun, 06 Apr 2008 10:46:19 +0200
From: Marko Macek <Marko.Macek@gmx.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>, "John T." <j.thomast@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
References: <205509.99433.qm@web45710.mail.sp1.yahoo.com> <alpine.LNX.1.00.0803231942380.3157@fbirervta.pbzchgretzou.qr> <47ED7EBD.8070009@zytor.com>
In-Reply-To: <47ED7EBD.8070009@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:

> One would also like to distinguish, say, Backspace from Ctrl-H.  This is 
> trickier, because the termios settings don't permit compound keys.  The 
> most obvious way to deal with that is an escape code for Ctrl-H, but 
> that has the risk of breaking a lot of other things.

Backspace is not a problem, since it generates ^? (DEL/127) on Linux 
since the early days.

It would be really nice to be able get arbitrary modifier combinations for all keys
and a separate combination for the escape key.

Mark
