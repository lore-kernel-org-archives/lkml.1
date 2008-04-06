Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYDFQiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYDFQiG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 12:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYDFQhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 12:37:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45405 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836AbYDFQhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 12:37:48 -0400
Message-ID: <47F8FC50.2010406@zytor.com>
Date: Sun, 06 Apr 2008 09:37:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Marko Macek <Marko.Macek@gmx.net>
CC: Jan Engelhardt <jengelh@computergmbh.de>, "John T." <j.thomast@yahoo.com>,
       linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
References: <205509.99433.qm@web45710.mail.sp1.yahoo.com> <alpine.LNX.1.00.0803231942380.3157@fbirervta.pbzchgretzou.qr> <47ED7EBD.8070009@zytor.com> <47F88DDB.30409@gmx.net>
In-Reply-To: <47F88DDB.30409@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marko Macek wrote:
> H. Peter Anvin wrote:
> 
>> One would also like to distinguish, say, Backspace from Ctrl-H.  This 
>> is trickier, because the termios settings don't permit compound keys.  
>> The most obvious way to deal with that is an escape code for Ctrl-H, 
>> but that has the risk of breaking a lot of other things.
> 
> Backspace is not a problem, since it generates ^? (DEL/127) on Linux 
> since the early days.
> 
> It would be really nice to be able get arbitrary modifier combinations 
> for all keys and a separate combination for the escape key.
> 

Yes; this probably needs to be modal, but we can probably live with that.

	-hpa
