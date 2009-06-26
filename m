Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbZFZKR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbZFZKR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 06:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZFZKRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 06:17:22 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:34835 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZFZKRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 06:17:21 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A44A026.3050207@cam.ac.uk>
Date: Fri, 26 Jun 2009 10:17:10 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@sirena.org.uk>,
       mike.rapoport@gmail.com, eric miao <eric.y.miao@gmail.com>
Subject: Re: da9030: ldo11 ignores disable
References: <4A439A2B.2020706@cam.ac.uk> <1246009446.30631.27.camel@vega.slimlogic.co.uk>
In-Reply-To: <1246009446.30631.27.camel@vega.slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liam Girdwood wrote:
> On Thu, 2009-06-25 at 15:39 +0000, Jonathan Cameron wrote:
>> Hi All,
>>
>> Whilst testing a regulator machine config I've run into a weird issue.
>>
>> The preliminary data sheet I have suggests that there are two enable
>> registers
>> for ldo11 but neither rctl22 or rctl11 seems to have any effect (on
>> their own
>> or both cleared together). I can change the voltage just fine, but not
>> actually turn it off.
>>
>> Anyone come across this problem or have any idea what is going on?
> 
> I've come across something similar in the past with two enable bits
> causing I2C register cache coherency issues. The cache bits became out
> of sync with reality and stopped some I2C writes happening.
Don't thing that could happen here.
> 
> Another option is that your hardware config doesn't allow ldo11 to be
> disabled ?
Other than the obvious possibility that the hardware has a bug, I can't
seem to find a reason why this shouldn't work.

Thanks,

Jonathan
