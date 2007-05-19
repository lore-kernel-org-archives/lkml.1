Return-Path: <linux-kernel-owner+w=401wt.eu-S1764361AbXESWG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764361AbXESWG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbXESWGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:06:22 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:21902 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178AbXESWGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:06:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=VK4Z5wHIazvNYiWkLtnIj+HVZFlKfn5xIyQhoIOtg+N43x9wEDy3xQwAg3yT/kn6V1astxTGQWkGkFVxafPNycGfeL3sDY5gZ6BrRyJeXsBYFHo50Y03AQ1pGYj2Wr7tKVNqkEMrUm0ZU6imCCAFITaih2RwYYUtz+Ojf2iYSqE=
Message-ID: <464F74C4.5070404@googlemail.com>
Date: Sun, 20 May 2007 00:05:56 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Uwe Bugla <uwe.bugla@gmx.de>, xfs-masters@oss.sgi.com,
       David Chinner <dgc@sgi.com>,
       Maurice van der Pot <griffon26@kfk4ever.com>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       Christoph Lameter <clameter@sgi.com>, Indan Zupancic <indan@nul.nu>,
       Dave Airlie <airlied@linux.ie>
Subject: Re: [2/5] 2.6.22-rc2: known regressions
References: <464F6DC9.80805@googlemail.com>
In-Reply-To: <464F6DC9.80805@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc2.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Block devices

Subject    : loop devices limited to one single device
References : http://lkml.org/lkml/2007/5/16/229
Submitter  : Uwe Bugla <uwe.bugla@gmx.de>
Status     : Unknown



File systems

Subject    : File on XFS is truncated at reboot with 2.6.22-rc1
References : http://bugzilla.kernel.org/show_bug.cgi?id=8503
Submitter  : Maurice van der Pot <griffon26@kfk4ever.com>
Status     : Unknown



Memory management

Subject    : SLAB doesn't like usb_get_configuration()
References : http://lkml.org/lkml/2007/5/19/96
Submitter  : Indan Zupancic <indan@nul.nu>
Status     : Unknown

Subject    : BUG: at mm/slab.c:777 __find_general_cachep()
References : http://lkml.org/lkml/2007/5/18/17
Submitter  : Jeff Garzik <jeff@garzik.org>
Status     : Unknown

Subject    : kernel BUG at include/linux/slub_def.h:88 kmalloc_index()
References : http://bugzilla.kernel.org/show_bug.cgi?id=8476
Submitter  : Cherwin R. Nooitmeer <cherwin@gmail.com>
Status     : Unknown



Regards,
Michal

--
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
