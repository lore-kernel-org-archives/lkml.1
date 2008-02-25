Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbYBYSXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbYBYSXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYBYSXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:23:35 -0500
Received: from www17.your-server.de ([213.133.104.17]:33217 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbYBYSXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:23:35 -0500
Message-ID: <47C3079E.9080309@m3y3r.de>
Date: Mon, 25 Feb 2008 19:23:26 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20080211)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.25-rc2: ohci1394 problem
References: <47BBDB07.80409@m3y3r.de> <47BBF771.40203@s5r6.in-berlin.de> <47BC6918.4000203@m3y3r.de> <47BC6E42.10409@s5r6.in-berlin.de> <47BC6EEC.4020000@s5r6.in-berlin.de> <47C04F99.6030704@m3y3r.de> <47C05A51.7000209@s5r6.in-berlin.de>
In-Reply-To: <47C05A51.7000209@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter schrieb:
>
> My conclusion so far:  There is something wrong with your system which 
> is below/ before the control of the ieee1394 or firewire stack.
Yes. I agree with you. So i did a "make clean" and a "make" (not a make 
-j3 as i use to do) and recompiled 2.6.25-rc3 and now it works again. 
Case closed under strange error. Thanks for your support.
>
> BTW, there was a single change to ohci1394 after v2.6.24 and that does 
> not affect the initialization code of ohci1394.  (Patch name is 
> "ieee1394: ohci1394: don't schedule IT tasklets on IR events".)  Did 
> you ever use kernels before 2.6.25-rc2 and had both of ohci1394 and 
> firewire-ohci inserted?
Yes. 2.6.24 works with the same config, i.e. both drivers are build as 
modules.

mfg
thomas

