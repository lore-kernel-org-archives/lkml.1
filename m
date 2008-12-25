Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbYLYStE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbYLYStE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 13:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYLYSsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 13:48:53 -0500
Received: from trickle.CC.McGill.CA ([132.206.27.51]:52484 "EHLO
	trickle.cc.mcgill.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbYLYSsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 13:48:53 -0500
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Dec 2008 13:48:52 EST
Subject: Kernel panic with upgrade to 2.6.28
From: David Ronis <ronis@ronispc.chem.mcgill.ca>
Reply-To: ronis@ronispc.chem.mcgill.ca
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Department of Chemistry, McGill University
Date: Thu, 25 Dec 2008 13:42:17 -0500
Message-Id: <1230230537.3368.13.camel@montroll.chem.mcgill.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.4 
X-PMX-Version: 5.4.2.338381, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2008.11.25.160724
X-McGill-WhereFrom: Internal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just upgraded from 2.6.27.8 or .10 to 2.6.28 on several machines.  On
one, a Dell dimension 3000 with a dual-core pentium R chip,  2 Seagate
ST340014A (/dev/hda with swap as partion 1 and root ext3 filesystem as
partion 2 and b containing a windows partition) and running slackware
12.1, I get a kernel panic when trying to boot (the others boot fine);
specifically, I get:

        Cannot open root device "302" or unknown block(3,2).  Please
        append a correct root=; here are the available partitions:
        
No partitions are shown.  Manually adding root=/dev/hda2 to the lilo
boot prompt doesn't help either.

The 2.6.27.8 kernel boots fine.

Any suggestions?  Please CC me directly.

Thanks and Happy Holidays

David


