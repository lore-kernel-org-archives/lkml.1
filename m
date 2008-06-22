Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbYFVSZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbYFVSZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 14:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYFVSZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 14:25:23 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:34420 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbYFVSZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 14:25:22 -0400
Message-ID: <485E992B.8010101@keyaccess.nl>
Date: Sun, 22 Jun 2008 20:25:47 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [REGRESSION, ABI] Re:  LMSENSORS: 2.6.26-rc, enabling
 ACPI Termal Zone support costs sensors
References: <485DA11C.7050906@keyaccess.nl> <485DFF35.6080008@hhs.nl>	<485E505F.8010306@keyaccess.nl> <485E61DE.6020202@hhs.nl> <485E6F12.4010307@keyaccess.nl> <485E94ED.10602@hhs.nl>
In-Reply-To: <485E94ED.10602@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-06-08 20:07, Hans de Goede wrote:

> Rene Herman wrote:
>> On 22-06-08 16:29, Hans de Goede wrote:
>>
>>> Rene Herman wrote:
>>>> This is an ABI breakage issue and an unfortunate one at that:
>>>>
>>>
>>> No it is not, in 2.6.26rcX, the acpi thermalzones have grown a hwmon 
>>> interface, that is they register a hwmon device so that "sensors" and
>>
>> [ ... ]
>>
>> Now what? Yes it is. 2.6.25.7 works and 2.6.26-rcX with the same 
>> config options and the same userspace does not.
> 
> Know what? No it isn't. Just because some random userspace apps breaks 
> because certain _assumptions_ no longer hold true, does not make 
> something an ABI breakage.
> 
> I agree with you that the results are still no good though.
> 
> Know something else? I've just stopped caring about this issue, I'm not 
> the author of the changes causing said breakage. I'm merely an 
> lm_sensors (both userspace and kernel space) developer who was heavily 
> involved in getting this fixed for lm_sensors-3.0.2, and I believe that 
> adding yet another kconfig option which we then carry for years and 
> years is _not_ a good solution. Some userspace utlities like udev sit 
> very close to the kernel and sometimes an kernel update mandates a new 
> udev. To me this is much the same.
> 
> But at the end of the day, I do not feel responsible for this as I'm not 
> the author of the code causing the breakage. I'm just someone who knows 
> the ins and outs and tried to help, but given the treatment and thanks 
> I've been getting for my help I'm stopping with helping now.

What on earth are you talking about? Could you please re-read? I didn't 
  "treat badly" you, hwmon, acpi or whatever.

I'm simply pointing out the problem that 2.6.26 is going to break all 
setups using lm_sensors 2.0 (which among many, many others includes 
every single slackware and derivative system on the planet).

We are not having a flamewar. If you think that every disagreement or 
pointing out of a problem constitutes as much, that in itself is a 
problem but it's not mine. I reported the problem and then posted a 
patch that solves it one particular way.

Another way to solve it _could_ be to just make up a device link if 
something generic is available so that sensors doesn't trip over it in 
the first place but I don't know if that's a good option. You might.

I haven't a clue what you're talking about. Treatment? What treatment? I 
just want to get the above mentioned problem fixed and didn't suggest 
anything else. Let's get the problem fixed.

Rene.
