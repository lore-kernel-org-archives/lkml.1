Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704Ab0AJCAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab0AJCAK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 21:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128Ab0AJCAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 21:00:09 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:48664 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab0AJCAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 21:00:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=mx/+dHLt2tQDarJ0kmjYNMRWr3+bBTrX9dFkkey6b6cngjn6x0tbUt0yWSyFOzLbB3
         OAunaxdP4Tlr7wS9W9veLOwUzLi3sIq+yc5UU9UXh9EzdZrwR64nEaRdCgRFG/Hmyv9L
         3SRa1JjNpaIQQPlnLPf+l5fuCQLcX4QvAH8Xg=
Message-ID: <4B4934A5.6000802@googlemail.com>
Date: Sun, 10 Jan 2010 03:00:05 +0100
From: Marco Calignano <marcuzzo.linux@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091230 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Strange Console behavior on Kernel Update
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just downloaded today the kernel 2.6.33-r3-git2 and recompiled using
make oldconfig with the configuration of my 2.6.29-gentoo Kernel.
I have a Problem that I am not really sure is caused from the Kernel but
it is the only variable that changes in the equation so I try asking
what do you think about this.
For the first part everything works fine all my hardware is recognized
and every driver write its output in a normal way
When the sysvinit application starts, a weird thing happens and a bunch
of escape characters (actually always the same one "[25~") appears on my
monitor in between the console output.
At the end of the booting process I cannot even login because of this
phenomenon and I have to reload the old kernel.
I tried even to disconnect the  keyboard or the mouse thinking could be
an bad hardware setting but no changes.
I was looking on Internet for similar bug reports but I didn't find
anything. Looking at the code of the sysvinit application I suspect that
the only difference is that sysvinit uses printf from user space opening
a console while all drivers use printfk.
Like I said the only think changing is the  Kernel not the rest.
I will get the last release of the 2.6.29 kernel from the git and see if
with that kernel I have the same problem or not.

Thanks

-- 
Marco Calignano
