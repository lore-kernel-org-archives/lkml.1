Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbYFWOFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbYFWOFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 10:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbYFWOFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 10:05:41 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:56260 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYFWOFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:05:40 -0400
Message-ID: <485FADDC.4010108@keyaccess.nl>
Date: Mon, 23 Jun 2008 16:06:20 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>, linux-acpi@vger.kernel.org,
       Zhang Rui <rui.zhang@intel.com>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: LMSENSORS: 2.6.26-rc,  enabling ACPI Termal Zone support costs
   sensors
References: <485DA11C.7050906@keyaccess.nl>	<485DFF35.6080008@hhs.nl>	<485E505F.8010306@keyaccess.nl>	<485E61DE.6020202@hhs.nl>	<20080623120844.5f722aa6@hyperion.delvare>	<485F79C6.20507@keyaccess.nl>	<20080623135704.2980078c@hyperion.delvare>	<485F9877.1060902@keyaccess.nl> <20080623154715.3ac8e984@hyperion.delvare>
In-Reply-To: <20080623154715.3ac8e984@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23-06-08 15:47, Jean Delvare wrote:

>> This cannot be the reason, because it's not wrong. We just need a device 
>> backlink. Basically, any single one will do. It's just about keeping 
>> lm-sensors 2 happy.
> 
> Your patch _is_ wrong. You make the device link point to _one_ of the
> devices that belong to the thermal zone, arbitrarily. If the device is
> removed before the thermal zone itself is, what happens?

As Zhang Rui said, this cannot happen in reality. I'll stop talking to 
you. Kernel side, it's not your problem anyway, it's an ACPI Thermal 
Zone one. Guess I'll go ask the 2.6.26 release manager if he feels that 
breaking existing lm-sensors 2 userspace systems is acceptable. I myself 
obviously know how to fix things by now.

Admittedly I need to find another hobby because the regularity with 
which people on this list piss me off is definitely disturbing. I also 
have this depressing notion that it might just be people pissing me off 
with frightening regularity period, but oh well.

Gardening... maybe I'll do gardening now.

Rene.
