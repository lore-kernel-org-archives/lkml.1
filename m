Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbZFYPjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbZFYPjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbZFYPji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:39:38 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:37328 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbZFYPji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:39:38 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A439A2B.2020706@cam.ac.uk>
Date: Thu, 25 Jun 2009 15:39:23 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@sirena.org.uk>,
       Liam Girdwood <lrg@kernel.org>, mike.rapoport@gmail.com,
       eric miao <eric.y.miao@gmail.com>
Subject: da9030: ldo11 ignores disable
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Whilst testing a regulator machine config I've run into a weird issue.

The preliminary data sheet I have suggests that there are two enable
registers
for ldo11 but neither rctl22 or rctl11 seems to have any effect (on
their own
or both cleared together). I can change the voltage just fine, but not
actually turn it off.

Anyone come across this problem or have any idea what is going on?

Thanks,

Jonathan
