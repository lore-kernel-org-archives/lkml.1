Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbZG1Koj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbZG1Koj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZG1Koj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:44:39 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:52748 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753068AbZG1Koh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:44:37 -0400
Date: Tue, 28 Jul 2009 11:44:34 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org
Subject: Converting to dev_pm_ops (remove annoying warnings)
Message-ID: <20090728104434.GA1728@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a couple of questions about changing drivers to use the
dev_pm_ops method within drivers using the device driver model.

1) Should the suspend/resume code still be wrapped in #ifdef CONFIG_PM
   and supply a NULL 'struct dev_pm_ops' wen CONFIG_PM=n

2) Is it allowable to submit changes to move drivers to dev_pm_ops
   during the -rc phase, or do we have to wait for the merge window
   before sending these? The number of warnings on a system that
   relies heavily on platform devices is annoying (S3C24XX ARM).

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
