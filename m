Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936248Ab0BZNgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 08:36:45 -0500
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:51098 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936110Ab0BZNgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 08:36:44 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B87CEE4.9090104@jic23.retrosnub.co.uk>
Date: Fri, 26 Feb 2010 13:38:44 +0000
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Nitin Shah <Nitin.Shah@kpitcummins.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Liam Girdwood <lrg@kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Touch Screen Drivers for Dialog da9052
References: <F56EA673D3E56E48804FE2B0D23EFD2D21346D8A9D@KCINPUNHJCMS01.kpit.com>
In-Reply-To: <F56EA673D3E56E48804FE2B0D23EFD2D21346D8A9D@KCINPUNHJCMS01.kpit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/10 12:36, Nitin Shah wrote:
> Hi,
> 
> We have developed Touch Screen (TSI) Drivers for Dialog da9052 Power
> Management IC.
> 
> We have tested this driver on Samsung SMDK-6410 board. If any one
> needs test application tor testing this driver, we will provide the
> same which we have used for testing.
> 
> For more details about the attached drives please refer the README
> file inside "da9052_drivers.zip".
> 
> We would like to incorporate this driver into Linux mainline kernel.
> 
> Please test the driver and provide your valuable comments and
> feedback.
> 
> Thanks & Regards, Nitin Shah
Hi Nitin,

Couple of initial points.  Please take a look at the guidance on
Submitting patches in the Documentation directory of the linux
kernel source tree. To get more eyes on code you need to make it
as simple as possible for people to take a look!

To move this driver set towards merging, take a look at how the other
da90xx chips are handled in the current kernel.  Given the chips have
a lot of different functionality fitting into numerous corners of the
kernel, that a given user may or may not want to use, they are implemented
as multifunction devices (drivers/mfd) with children in a number of other
subsystems.

Whilst the code you have sent is pretty clear and well commented etc, it
is going to need a lot of changes to interface with the relevant kernel
subsystems.

Perhaps this is one for staging? 

I've cc'd in a few other relevant people to bring it to their attention.
Note all, while the email only mentioned touch screen drivers, this a pretty
comprehensive pmic driver with tsi, adc, gpio, regulator control and various
other bits and bobs.

Jonathan




