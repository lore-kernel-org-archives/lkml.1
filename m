Return-Path: <linux-kernel-owner+w=401wt.eu-S1030659AbXBGU7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030659AbXBGU7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 15:59:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030640AbXBGU7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 15:59:10 -0500
Received: from 81-174-33-43.f5.ngi.it ([81.174.33.43]:50521 "EHLO develer.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1030659AbXBGU7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 15:59:08 -0500
X-Spam-Virus: No
Message-ID: <45CA3D1E.9030203@develer.com>
Date: Wed, 07 Feb 2007 21:57:02 +0100
From: Bernardo Innocenti <bernie@develer.com>
Organization: Develer S.r.l. - http://www.develer.com/
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: dougg@torque.net
CC: mpt_linux_developer@lsil.com, lkml <linux-kernel@vger.kernel.org>,
       Develer IT Infrastructure <it@lists.develer.com>,
       linux-scsi@vger.kernel.org
Subject: Re: Writing performance problem with SAS1068
References: <45C84333.709@develer.com> <45C8D686.7010103@torque.net>
In-Reply-To: <45C8D686.7010103@torque.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Feb  7 21:58:45 2007
X-DSPAM-Confidence: 0.9997
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 45ca3d85255367224429326
X-DSPAM-Factors: 27,
	Organization*http+www, 0.00010,
	Subject*Re+Writing, 0.00010,
	CC*kernel, 0.00010,
	CC*kernel, 0.00010,
	CC*lkml+linux, 0.00010,
	CC*lkml, 0.00010,
	CC*kernel+org, 0.00010,
	CC*kernel+org, 0.00010,
	Organization*www, 0.00010,
	CC*vger, 0.00010,
	CC*vger, 0.00010,
	CC*vger+kernel, 0.00010,
	CC*vger+kernel, 0.00010,
	Develer+S, 0.00010,
	CC*org, 0.00010,
	CC*org, 0.00010,
	CC*linux, 0.00017,
	CC*linux, 0.00017,
	Subject*Writing+performance, 0.00020,
	CC*scsi+vger, 0.00020,
	Subject*SAS1068, 0.00020,
	CC*developer, 0.00020,
	CC*scsi, 0.00020,
	Subject*with+SAS1068, 0.00020,
	Subject*performance+problem, 0.00020,
	CC*linux+scsi, 0.00020,
	CC*linux+kernel, 0.00021
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Douglas Gilbert wrote:

> You may like to check that Write Cache Enable is on with:
> 'sdparm --get=WCE /dev/sdd'.

Yeah, yeah!  Works fine once I toggled the WCE to 1.  Writing
flies at 70MB/s, which is extremely good for those desktop-grade
disks (Seagate Barracuda SATA 250GB @7200RPM).

Thank you very much!

But... who do you think I should bug to make this the system
default?  Does write caching need to be enabled by the driver
itself, in the SCSI layer or perhaps by the distro initscripts?

-- 
   // Bernardo Innocenti - Develer S.r.l., R&D dept.
 \X/  http://www.develer.com/
