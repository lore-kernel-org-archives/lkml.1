Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbYLUDL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbYLUDL0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 22:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYLUDLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 22:11:18 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:37548 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbYLUDLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 22:11:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ZZPuk++ed3dZBx13SMzlMmSYFq/ArPhc92UyfDle5jo9tpvnwFW2OhSBcjEF/MIC++
         THHQyPE+gkMmxMz3NEI43kIX+tVNo2bfI+14U/LBDxeE9WWklGUxHMFaXPZXcYMcY+Lk
         +dTddD4MIPIhW+EUjhVnXJ3dWTWzvwswsyyPU=
Message-ID: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com>
Date: Sat, 20 Dec 2008 22:11:17 -0500
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc9: USB Mouse unhappy
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just installed today's git on my workstation and my Logitech USB Mouse
only wants to move vertically around the centre of the monitor.

I have no clue where to look - all  I know is that it works with the
2.6.27 and various 2.6.28-rcs prior to this one.

Parag

[parag@xw6600 ~]$ diff Xorg.0.log.not.working /var/log/Xorg.0.log |grep Logi
< (**) Logitech USB Receiver: Device: "/dev/input/event5"
> (**) Logitech USB Receiver: Device: "/dev/input/event6"
< (II) config/hal: Adding input device Logitech USB Receiver
< (**) Logitech USB Receiver: always reports core events
< (**) Logitech USB Receiver: Device: "/dev/input/event3"
< (II) Logitech USB Receiver: Found x and y relative axes
< (II) Logitech USB Receiver: Found mouse buttons
< (II) Logitech USB Receiver: Configuring as mouse
< (II) XINPUT: Adding extended input device "Logitech USB Receiver"
(type: MOUSE)
> (II) config/hal: Adding input device Logitech USB Receiver
> (**) Logitech USB Receiver: always reports core events
> (**) Logitech USB Receiver: Device: "/dev/input/event5"
> (II) Logitech USB Receiver: Found x and y relative axes
> (II) Logitech USB Receiver: Found mouse buttons
> (II) Logitech USB Receiver: Configuring as mouse
> (II) XINPUT: Adding extended input device "Logitech USB Receiver" (type: MOUSE)
