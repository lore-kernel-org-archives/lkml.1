Return-Path: <linux-kernel-owner+w=401wt.eu-S1759689AbYFWRJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689AbYFWRJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbYFWRJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:09:31 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:54962 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbYFWRJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:09:30 -0400
Message-ID: <485FD8F1.7070307@keyaccess.nl>
Date: Mon, 23 Jun 2008 19:10:09 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Jean Delvare <khali@linux-fr.org>, Hans de Goede <j.w.r.degoede@hhs.nl>,
       linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: LMSENSORS: 2.6.26-rc,  enabling ACPI Termal Zone support costs
 sensors
References: <485DA11C.7050906@keyaccess.nl> <485DFF35.6080008@hhs.nl> <485E505F.8010306@keyaccess.nl> <485E61DE.6020202@hhs.nl> <20080623120844.5f722aa6@hyperion.delvare> <485F79C6.20507@keyaccess.nl> <20080623135704.2980078c@hyperion.delvare> <485F9877.1060902@keyaccess.nl> <20080623143112.GA4160@srcf.ucam.org>
In-Reply-To: <20080623143112.GA4160@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.7 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23-06-08 16:31, Matthew Garrett wrote:

> On Mon, Jun 23, 2008 at 02:35:03PM +0200, Rene Herman wrote:
>> libsensors dictated the ABI rule that the hwmon directories must have 
>> device backlinks; the new ACPI Thermal Zone hwmon interface breaks that 
>> bit of ABI. It is not relevant that that ABI may have gotten to be as a 
>> result of unfortunate programming on the userspace side -- the only 
>> thing relevant is that it IS. lm-sensors 2 is on millions of systems out 
>> there. This is not meant agressively, or whatever you guys seem to want 
>> to read in my words, it's un undeniable fact.
> 
> No, libsensors made an assumption about the ABI that turns out not to be 
> true. The ABI hasn't changed, libsensors is just being exposed to a case 
> it didn't previously see.
> 
> We've had this kind of change before. The ACPI backlight code changed in 
> such a way that scripts that blindly wrote values instead of (correctly) 
> reading the maximum brightness value broke. mmap's behaviour changed in 
> such a way that it was no longer possible for vm86 to execute code that 
> wasn't mapped as executable, breaking libx86. The applications in 
> question were undeniably buggy. Those are examples that I was personally 
> involved with - I'm sure there are others. Where userspace has made 
> false assumptions, it's not the kernel's responsibility to continue to 
> support those assumptions.

We are not going to agree. In this, it's not a random application, but the
one and only interface to sensors that's in use that breaks. It is all of
sensors support that breaks, all user interfaces, as they all depend on the
one libsensors. Sure, if some random application makes bad assumptions the
remedy is fixing the random application. If the one and only interface to
something breaks, it's the ABI that breaks.

And if people really insist on calling it FNOOZLEGLUM breakage instead of
ABI breakage, all for it. I love exciting words. Its just that I'm really
more interested in the "breakage" bit than anyone else in this thread it
seems.

Rene.
