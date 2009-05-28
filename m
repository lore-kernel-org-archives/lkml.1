Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbZE1FO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbZE1FO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 01:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756432AbZE1FOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 01:14:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:32734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbZE1FOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 01:14:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JavOdS9OARcKEr5DGyEeWocrkD91bruxBTumh/+RMXsw18P9pMCBIiMPPlu1LRIObg
         sG6vq66swQJGz4wZ09JxvcS8e8/HI2sFyzNsEKaT5KvB6ytGTPeivYF05Ut6pWPVvDnF
         fUdEHKTy8rwKnDsBnSYgb207ldPSHRYpomBz4=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Eric Miao <eric.miao@marvell.com>
Subject: 
Date: Thu, 28 May 2009 07:15:15 +0200
Message-Id: <1243487718-5423-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <878wkibmv9.fsf@free.fr>
References: <878wkibmv9.fsf@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I tried to include all proposed changes in 1/3. As you can see, for
R24=5.11kOhm and 7.5kOhm the maximum V3 voltage doesn't reach the nominal
value from the data sheet, but as I only need the nominal 1.55V for
R24=3.32kOhm to make pxa2xx-cpufreq happy, this is good enough for me.

Patch 2/3, 3/3 depend on this and should go into Eric's pending tree once
this is settled.

regards
Philipp

