Return-Path: <linux-kernel-owner+w=401wt.eu-S1031169AbXEAMlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031169AbXEAMlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 08:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031205AbXEAMlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 08:41:35 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:19073 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031169AbXEAMle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 08:41:34 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2007 08:41:34 EDT
From: Stefan Roese <ml@stefan-roese.de>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Correct location for ADC/DAC drivers
Date: Tue, 1 May 2007 14:35:44 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705011435.45046.ml@stefan-roese.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-RZG-AUTH: j/Xgg0n2J5AIUJCkqLmy+bJbs1jMc+ebRMH8X0gX2f46QMnUI4cTITA7kWi4aTamHuFtiA==
X-RZG-CLASS-ID: mo00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm in the stage of integrating some ADC and DAC drivers for the AMCC 405EZ 
PPC and looking for the correct location to place these drivers in the Linux 
source tree. The drivers are basically character-drivers, so my first thought 
is to put them in "drivers/char/adc/foo.c" or "drivers/char/adc_foo.c". Is 
this a good solution?

Any suggestions welcome (could be that I missed an already existing example).

BTW: I am aware of the hwmon subsystem, but I don't think it fits my needs in 
this case.

Best regards,
Stefan
