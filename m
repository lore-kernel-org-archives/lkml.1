Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbXEWCZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbXEWCZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 22:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbXEWCZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 22:25:45 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:40588
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464AbXEWCZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 22:25:44 -0400
From: Rob Landley <rob@landley.net>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Cleaning up the Documentation directory.
Date: Tue, 22 May 2007 22:25:39 -0400
User-Agent: KMail/1.9.1
Cc: linux-doc@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705222225.39949.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to reorganize the Documentation directory, starting with the 
following:

  cd Documentation
  mkdir -p arch/amiga
  mv zorro.txt arch/amiga
  mv arm cris blackfin parisc powerpc s390 x86_64 uml arch
  mv sx.txt stallion.txt specialix.txt rocket.txt riscom8.txt \
     computone.txt hayes-esp.txt moxa-smartio serial

I could send a patch to do this, but moving files via patch is icky.  Would it 
be better to start a git tree and ask people to pull from it, or to send in 
script snippets like the above?

Rob
