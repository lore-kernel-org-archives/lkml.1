Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbYBMIjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbYBMIjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYBMIjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:39:24 -0500
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:52380 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbYBMIjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:39:23 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: "avoid overflows in kernel/time" breakes my ondemand scheduler
Date: Wed, 13 Feb 2008 09:38:50 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200802130938.50749.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello H. Peter,

the patch "avoid overflows in kernel/time" makes the ondemand cpufreq 
scheduler unusable. It looks like the cpufreq scheduler takes minutes to 
react on load changes.

I looked at the patch but did not found an obvious problem. Reverting this 
patch seems to fix the problem.

Do you have any ideas?

Christian 
