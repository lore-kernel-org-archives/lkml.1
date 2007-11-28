Return-Path: <linux-kernel-owner+w=401wt.eu-S1760226AbXK1BHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226AbXK1BHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 20:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbXK1BHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 20:07:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:55525 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbXK1BHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 20:07:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jvj/ofUV2xEm0wEHz8DJCu2DOSr6rQHv9c5LN3qzexRydDrLJV55rmE8cGyuQwD98d+YOPVz+WPgQVk79xZ0uDTiAUG7dfb74Of4TMON6uT6YWRiJgN34V75dowxLNpdFI6JaVOxJQ0j00ysAGkkbhiMJkkbIhEG3gvKO7tU3j8=
Message-ID: <2accc2ff0711271707o636c060ck7587a259dab92917@mail.gmail.com>
Date: Tue, 27 Nov 2007 20:07:16 -0500
From: "Nelson Castillo" <nelsoneci@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Module for keyboard statistics / What should I look at?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

More than 2 years ago I wrote a small non-portable patch [1] to gather
some statistics
about keyboard usage[2] ( I show the counters with modulo 10 but still this is a
security risk. Perhaps some random noise should be added ).

[1] http://svn.arhuaco.org/svn/src/pcgotchi/trunk/proc-keystrokes.patch.linux-2.6.12.2.txt
[2] http://pcgotchi.blogspot.com/2005/10/11140-times.html

I liked to use this in my PC but stopped using this because I didn't
want to compile whenever I
upgraded Kernels (Debian).

I thought I had already asked in LKML as suggested by Blaisorblade[3],
but I did ask in
kernelnewbies instead[4].

[3] http://www.mail-archive.com/user-mode-linux-devel@lists.sourceforge.net/msg02168.html
[4] http://mail.nl.linux.org/kernelnewbies/2006-05/msg00367.html

My questions are:

* What should I read to do this in a module?
* Is there a better way to to this? (perhaps using /dev/input/... and
a user-space program) ?

Regards,
Nelson.-

PS: I don't wish to write a keylogger. I really want the statistics
and you are screwed if
someone gets to be root in your machine anyway.

-- 
http://arhuaco.org
