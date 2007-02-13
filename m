Return-Path: <linux-kernel-owner+w=401wt.eu-S1751222AbXBMJaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbXBMJaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 04:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbXBMJaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 04:30:18 -0500
Received: from outmx018.isp.belgacom.be ([195.238.4.117]:35089 "EHLO
	outmx018.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbXBMJaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 04:30:16 -0500
From: Laurent Pinchart <laurent.pinchart@technotrade.biz>
Organization: Technotrade
To: linux-kernel@vger.kernel.org
Subject: git issues while fetching from http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
Date: Tue, 13 Feb 2007 10:29:59 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131030.00046.laurent.pinchart@technotrade.biz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

I'm trying to fetch from the Linux kernel repository at 
http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/. After 
downloading the objects, git failed while trying to fetch tags. Retrying the 
fetch operation gives the following output:

$ git-fetch origin
Fetching refs/heads/master from 
http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/ using 
http
Auto-following refs/tags/v2.6.20
Auto-following refs/tags/v2.6.20
Auto-following refs/tags/v2.6.20-rc1
Auto-following refs/tags/v2.6.20-rc1
Auto-following refs/tags/v2.6.20-rc2
Auto-following refs/tags/v2.6.20-rc2
Auto-following refs/tags/v2.6.20-rc3
Auto-following refs/tags/v2.6.20-rc3
Auto-following refs/tags/v2.6.20-rc4
Auto-following refs/tags/v2.6.20-rc4
Auto-following refs/tags/v2.6.20-rc5
Auto-following refs/tags/v2.6.20-rc5
Auto-following refs/tags/v2.6.20-rc6
Auto-following refs/tags/v2.6.20-rc6
Auto-following refs/tags/v2.6.20-rc7
Auto-following refs/tags/v2.6.20-rc7
Failed to fetch refs/tags/v2.6.20 from 
http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/

While trying to solve the issue, I noticed that the refs/tags directory in the 
remote repository is empty. Is that a normal situation ? Should git be able 
to regenerate the tags locally from the objects ? I'm using git 1.4.4.4.

Best regards,

Laurent Pinchart

PS: please CC me when replying to this e-mail. Thanks
