Return-Path: <linux-kernel-owner+w=401wt.eu-S1763187AbZDAMGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763187AbZDAMGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757919AbZDAMGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:06:07 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:50876 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883AbZDAMGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:06:06 -0400
Date: Wed, 1 Apr 2009 13:05:58 +0100
From: Andrew Price <andy@andrewprice.me.uk>
To: Frank Blaschka <frank.blaschka@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Commit 64ef89 left empty files
Message-ID: <20090401120557.GA12726@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After running 'make distclean' on a clone of Linus's linux-2.6 git tree today I
ran 'git status' and found that these two files had been deleted:

#	deleted:    drivers/s390/net/qeth_core_offl.c
#	deleted:    drivers/s390/net/qeth_core_offl.h

This seems to have happened because both of these files are empty and distclean
removes empty files. Since I use make-kpkg to script my kernel test builds
(which uses distclean) this is kind of inconvenient.

Please could these files be properly 'git rm'd if appropriate?

Thanks,

--
Andrew Price
