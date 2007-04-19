Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbXDSWnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbXDSWnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbXDSWnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:43:41 -0400
Received: from flpvm09.prodigy.net ([207.115.20.39]:57858 "EHLO
	flpvm09.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbXDSWnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:43:40 -0400
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2007 18:43:40 EDT
X-ORBL: [69.177.4.52]
Message-ID: <4627EED5.6020800@pcburn.com>
Date: Thu, 19 Apr 2007 18:36:05 -0400
From: Chris Bergeron <chris@pcburn.com>
Reply-To: chris@pcburn.com
Organization: PCBurn Media
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: GPL-incompatible Module Error Message
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Building the fglrx module against the current Linux kernel (2.6.20.7 as 
of this e-mail) I'm getting an error:

FATAL: modpost: GPL-incompatible module fglrx.ko uses GPL-only symbol 
'paravirt_ops'

which looks like someone (ATI?) might be doing something funny.  I'm 
just curious what the error means.. paravirt_ops is bit of the new 
virtualization code, correct?

Anyway, I'm curious if it's interesting or "nothing to see here, move 
along". I'm not looking for any kind of "fix" as the module itself not 
building isn't a kernel dev issue (currently having trouble with the 
Xorg Radeon drivers, but that's another story).

It just seemed like it might be interesting and I couldn't find anything 
to shed light on the error itself in the mailing list logs, and I'm 
curious at what's happening.

Thanks,
-- Chris
