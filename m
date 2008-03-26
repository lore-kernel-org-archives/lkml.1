Return-Path: <linux-kernel-owner+w=401wt.eu-S1759195AbYCZVCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbYCZVCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbYCZVB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:01:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48876 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYCZVB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:01:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47EAB9BB.5070209@s5r6.in-berlin.de>
Date: Wed, 26 Mar 2008 22:01:47 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: "make -j5 clean" breaks subsequent build
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-2.6.25-rc6:

$ while make -j5 clean all; do :; done

will eventually fail in make all due to target files not found.  The 
files differ from failure to failure.

$ while make clean && make -j5 all; do :; done

works fine in the very same source tree.  Happens on two different dual 
core PCs and different filesystems.  I have not yet tested if any other 
linux versions are affected.

(This has to be a known issue; isn't it?)
-- 
Stefan Richter
-=====-==--- --== ==-=-
http://arcgraph.de/sr/
