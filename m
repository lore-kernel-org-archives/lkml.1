Return-Path: <linux-kernel-owner+w=401wt.eu-S1031059AbXECJh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031059AbXECJh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030986AbXECJhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:37:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3884 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030973AbXECJhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:37:13 -0400
From: Mark Brown <broonie@sirena.org.uk>
To: Tim Hockin <thockin@hockin.org>, Jeff Garzik <jeff@garzik.org>
Cc: =?utf-8?b?UmFmYcWC?= Bilski <rafalbilski@interia.pl>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2007 10:36:44 +0100
Message-ID: <20070503093435.7800.38591.stgit@mercator.sirena.org.uk>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.32.140.119
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 0/2] natsemi: Improve DspCfg workaround
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The natsemi driver contains a workaround for broken hardware which can
on some boards cause more problems than it solves.  The following patch
series improves this by making the diagnostic more obvious and allowing
users to disable the workaround if it causes them problems.

-- 
"You grabbed my hand and we fell into it, like a daydream - or a fever."
