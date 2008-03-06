Return-Path: <linux-kernel-owner+w=401wt.eu-S1765072AbYCFMcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765072AbYCFMcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbYCFMbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:31:52 -0500
Received: from mail.dunaweb.hu ([81.17.184.3]:60363 "EHLO mail.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbYCFMbv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:31:51 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2008 07:31:51 EST
Message-ID: <47CFE29E.8080107@dunaweb.hu>
Date: Thu, 06 Mar 2008 13:25:02 +0100
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, akpm@linux-foundation.org, hancockr@shaw.ca,
       prakash@punnoor.de, pchen@nvidia.com, kluo@nvidia.com
Subject: SWNCQ should be enabled by default
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the patch is already upstream, thanks for that.
I am using it without any problems. Currently I am
using kernel-2.6.24.3-12.fc8 from the updates-testing
repository of Fedora 8. I had to add

options scsi_hostadapter1 swncq=1
options sata_nv swncq=1

before upgrading to get it enabled.
Can we enable it by default for 2.6.25?
It's completely independent from ADMA and its problems.
E.g. my machine has 8GB memory now, no problems at all.

Best regards,
Zoltán Böszörményi

