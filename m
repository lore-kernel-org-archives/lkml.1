Return-Path: <linux-kernel-owner+w=401wt.eu-S964912AbXBTOAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964912AbXBTOAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964915AbXBTOAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:00:53 -0500
Received: from marmot.shef.ac.uk ([143.167.1.4]:41152 "EHLO marmot.shef.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964912AbXBTOAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:00:52 -0500
X-Greylist: delayed 2013 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Feb 2007 09:00:52 EST
Subject: sparc64 / bbc_i2c.c
From: "J.J. Green" <j.j.green@sheffield.ac.uk>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: University of Sheffield
Date: Tue, 20 Feb 2007 13:27:12 +0000
Message-Id: <1171978032.18442.11.camel@lax.shef.ac.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
X-S0phie-Scan: no
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I got bitten by this problem on sparc64 (a blade 1000)

  http://ubuntuforums.org/showthread.php?t=297474

summary :

  modprobe bbc

runs kenvctrld which uses 100% of a CPU for 5 seconds,
then 0% for 5 seconds, then 100% .. and so on. The author
cited above suggests removing the line 

  remove_wait_queue(&bp->wq, &wait);

in the function 

  static int wait_for_pin(struct bbc_i2c_bus *bp, u8 *status)

Is there a better way?

I can test patches if that would be helpful.

Cheers

Jim
-- 
J.J. Green, Dept. Applied Mathematics, Hicks Bld.,
University of Sheffield, UK.   +44 (0114) 222 3742
http://pdfb.wiredworkplace.net/pub/jjg         



