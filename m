Return-Path: <linux-kernel-owner+w=401wt.eu-S1759668AbYBPD35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668AbYBPD35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 22:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYBPD3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 22:29:49 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:54172 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbYBPD3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 22:29:48 -0500
Message-ID: <47B6592A.6030200@keyaccess.nl>
Date: Sat, 16 Feb 2008 04:31:54 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org
Subject: 2.6.25-rc2 vdso_install breaks user "make install"
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day.

I have a ~/bin/installkernel which installs the kernel when I as user do a 
make install at the end of compilation but 2.6.25-rc2 seems to break this:

rene@7ixe4:~/src/linux/local$ make V=1 install
make -f scripts/Makefile.build obj=arch/x86/vdso vdso_install
mkdir: cannot create directory `/lib/modules/2.6.25-rc2': Permission denied

How to fix?

Rene.
