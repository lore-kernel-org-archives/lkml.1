Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591AbXD0Kze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbXD0Kze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbXD0Kze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:55:34 -0400
Received: from ppp198-178.static.internode.on.net ([59.167.198.178]:47037 "EHLO
	anu.rimspace.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbXD0Kzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:55:32 -0400
X-Greylist: delayed 2007 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2007 06:55:32 EDT
From: Daniel Pittman <daniel@rimspace.net>
To: Olivier Galibert <galibert@pobox.com>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <20070427001038.GA11265@dspnet.fr.eu.org> (Olivier Galibert's
	message of "Fri\, 27 Apr 2007 02\:10\:38 +0200")
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	<84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
	<1177573348.5025.224.camel@nigel.suspend2.net>
	<alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
	<1177607026.30284.197.camel@frg-rhel40-em64t-04>
	<alpine.LFD.0.98.0704261021160.9964@woody.linux-foundation.org>
	<1177618081.4737.42.camel@nigel.suspend2.net>
	<alpine.LFD.0.98.0704261343150.9964@woody.linux-foundation.org>
	<1177620656.4737.56.camel@nigel.suspend2.net>
	<20070427001038.GA11265@dspnet.fr.eu.org>
Date: Fri, 27 Apr 2007 20:21:41 +1000
Message-ID: <87mz0u86dm.fsf@rimspace.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.5-b27 (fiddleheads, linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olivier Galibert <galibert@pobox.com> writes:
> On Fri, Apr 27, 2007 at 06:50:56AM +1000, Nigel Cunningham wrote:
>
>> I'm perfectly willing to think through some alternate approach if you
>> suggest something or prod my thinking in a new direction, but I'm
>> afraid I just can't see right now how we can achieve what you're
>> after.
>
> Ok, what about this approach I've been mulling about for a while:
>
> Suspend-to-disk is pretty much an exercise in state saving.  There are
> multiple ways to do state saving, but they tend to end up in two
> categories: implicit and explicit.

[...]

> In explicit state saving each object saves what is needed from its
> state to an independently defined format (instead of "whatever the
> memory organization happens to be at that point").  When reloading the
> state you have to parse it, and it usually requires
> rebuilding/relocating all references/pointers/etc.  

If you are looking seriously at this you might want to start with the
code in the OpenVZ kernel (http://openvz.org) that allows a VE to
"checkpoint" to disk and "restore" on the same or a different machine.

This is, as far as I can tell, a portable implementation of this that
already handles real live userspace applications moving transparently
between two machines.

It has the advantage that it lives in an orderly world where most
devices and the file system are virtual but, hey, it works right now.

Regards,
        Daniel
-- 
Digital Infrastructure Solutions -- making IT simple, stable and secure
Phone: 0401 155 707        email: contact@digital-infrastructure.com.au
                 http://digital-infrastructure.com.au/
