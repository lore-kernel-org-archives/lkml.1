Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZIKJFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZIKJFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 05:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbZIKJFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 05:05:39 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:34160 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbZIKJFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 05:05:38 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AAA12EC.1090204@cam.ac.uk>
Date: Fri, 11 Sep 2009 10:05:48 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090803)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "lenb@kernel.org" <lenb@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
       "Cory T. Tusar" <ctusar@videon-central.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: RFC: Light sensors, unifying current options?
References: <4A9FC9D7.20000@cam.ac.uk>	<1252308744.3483.414.camel@rzhang-dt>	<4AA4F194.1070507@cam.ac.uk>	<1252467684.3483.446.camel@rzhang-dt>	<4AA79144.8060104@cam.ac.uk>	<1252546449.3483.476.camel@rzhang-dt>	<4AA8CF57.4010409@cam.ac.uk>	<1252634101.3483.514.camel@rzhang-dt> <20090911092049.70887ad0@hyperion.delvare>
In-Reply-To: <20090911092049.70887ad0@hyperion.delvare>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Fri, 11 Sep 2009 09:55:01 +0800, Zhang Rui wrote:
>> On Thu, 2009-09-10 at 18:05 +0800, Jonathan Cameron wrote:
>>> Some sensors, e.g. tsl2561 use an internal clock to do sampling and hence
>>> have some predefined period in which the reading taken doesn't change.
>>> Perhaps exporting said period would be useful to userspace?
>>>
>> I don't think so.
>> IMO, the tsl2561 driver should handle this, and there is no need to
>> annoy the user space.
>> i.e. users always assume the content of "illuminance" attribute is
>> valid, and it's the driver's job to make this true. We don't need to
>> document this.
> 
> I agree with Rui on this. Let's not delegate everything to user-space,
> otherwise it's pointless to write kernel drivers in the first place.
Agreed, if anyone has an application they can add the relevant hooks when
they need them.

