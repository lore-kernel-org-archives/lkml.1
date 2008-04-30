Return-Path: <linux-kernel-owner+w=401wt.eu-S934052AbYD3WU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052AbYD3WU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762156AbYD3WUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:20:09 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:19045 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761704AbYD3WUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:20:06 -0400
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: jclyXLBJ10ZHTmMMskdeEV9K+qamm4K24+0GzTHYHnheuzKtvddXf0g7srZHO6w=
Message-ID: <4818F093.3070105@hartkopp.net>
Date: Thu, 01 May 2008 00:20:03 +0200
From: Oliver Hartkopp <oliver@hartkopp.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: [RFC] Kernel naming convention in the merge phase
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

i wonder about the Kernel naming convention in the merge phase before
the -rc1 is officially tagged by Linus.

Won't it be more precisely to name the current snapshot
2.6.26-merge-git16 instead of 2.6.25-git16?

It is not that i would suggest to have a new git tag in this merge phase 
but only the Makefile should be changed at the beginning of this phase 
to identify the ongoing work for the 2.6.26:

------
diff --git a/Makefile b/Makefile
index d3634cd..b8c85a4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
VERSION = 2
PATCHLEVEL = 6
-SUBLEVEL = 25
-EXTRAVERSION =
-NAME = Funky Weasel is Jiggy wit it
+SUBLEVEL = 26
+EXTRAVERSION = -merge
+NAME = unnamed

# *DOCUMENTATION*
# To see a list of typical targets execute "make help"
------

Introducing the new '-merge' version _that_ early helps to avoid the 
version confusion in /lib/modules and also allows people to work with 
kernel version depended stuff in a very early phase.

Regards,
Oliver

