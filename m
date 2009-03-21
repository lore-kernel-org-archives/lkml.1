Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbZCUVOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbZCUVOU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 17:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZCUVOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 17:14:11 -0400
Received: from fsfla.org ([195.176.254.155]:37586 "EHLO fsfla.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbZCUVOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 17:14:10 -0400
X-Greylist: delayed 1278 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Mar 2009 17:14:10 EDT
To: linux-libre@fsfla.org, libreplanet-discuss@gnu.org,
       linux-kernel@vger.kernel.org
Subject: linux-2.6.28.8-libre1: suitable for Free System Distributions
From: Alexandre Oliva <lxoliva@fsfla.org>
Organization: Free thinker, not speaking for FSF Latin America
Date: Sat, 21 Mar 2009 17:51:57 -0300
Message-ID: <or7i2i7g5u.fsf@livre.oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several months ago, I realized the existing releases of Linux-libre,
that removed non-Free Software present in Linux, still retained code and
documentation that induced users to install and use non-Free Software.
This means it wasn't fit for use in Free System Distributions.

I started working to fix that bug back then.  Today, I'm very excited to
announce, straight from the Libre Planet 2009 conference organized by
the FSF, the first version of Linux-libre that won't do that any more.

The 2.6.28-libre1 release, and the patched 2.6.28.8-libre1 release, are
now available from http://linux-libre.fsfla.org/, bringing back several
drivers that used to be disabled before, and not disabling any driver
whatsoever.

Some of the drivers we used to disable have been modified so that they
now report the lack of Free firmware, instead of requesting users to
load non-Free Software into their systems.  These reports should be
useful for userland to pick up and report some useful, informative and
educational message to the user, explaining that their hardware is not
compatible with Free Software.

Other drivers we used to disabled contained suspicious strings that had
been conservatively removed.  Having verified the technical and legal
status of some of them, and having determined that some others weren't
code after all, this release brings them back in.  Some WiFi interfaces
and video capture devices, will be functional with this new release.

Other releases of Linux-libre, including past ones and the upcoming
2.6.29, will certainly require additional work, but nothing even close
to the amount of work it took to get to this one.  Thanks for your
patience.

I'd also like to thank the FSF for offering us our new build and web
server, the first in which this release was prepared, and Jeff Moe, who
had paid for our previous server.

Please report to linux-libre@fsfla.org any problems you run into with
this release (other than compile errors in a few dvb drivers, I'm on
those already), and let us know of any case in which you believe I may
have removed something that could have been retained.

Happier (and freer) hacking, :-)

-- 
Alexandre Oliva           http://www.lsd.ic.unicamp.br/~oliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
