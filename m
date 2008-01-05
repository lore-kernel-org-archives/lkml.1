Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359AbYAERU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbYAERU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 12:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYAERUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 12:20:17 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:15436 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbYAERUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 12:20:16 -0500
Message-ID: <477FBBE9.80108@oracle.com>
Date: Sat, 05 Jan 2008 09:18:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       david-b@pacbell.net
Subject: Re: 2.6.24-rc6-mm1 (build problem: gpio/W1)
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071231101920.5fb60a3d.randy.dunlap@oracle.com> <20080105152904.GB12982@2ka.mipt.ru> <20080105161657.GQ15861@sci.fi>
In-Reply-To: <20080105161657.GQ15861@sci.fi>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ville Syrjälä wrote:
> On Sat, Jan 05, 2008 at 06:29:04PM +0300, Evgeniy Polyakov wrote:
>> Hi Randy.
>>
>> Sorry for long delay.
>>
>> On Mon, Dec 31, 2007 at 10:19:20AM -0800, Randy Dunlap (randy.dunlap@oracle.com) wrote:
>>>   CC      drivers/w1/masters/w1-gpio.o
>>> In file included from /local/linsrc/linux-2.6.24-rc6-mm1/drivers/w1/masters/w1-gpio.c:19:
>>> include2/asm/gpio.h:4:18: error: gpio.h: No such file or directory
>>> /local/linsrc/linux-2.6.24-rc6-mm1/drivers/w1/masters/w1-gpio.c: In function 'w1_gpio_write_bit_dir':
>>> /local/linsrc/linux-2.6.24-rc6-mm1/drivers/w1/masters/w1-gpio.c:26: error: implicit declaration of function 'gpio_direction_input'
>>> /local/linsrc/linux-2.6.24-rc6-mm1/drivers/w1/masters/w1-gpio.c:28: error: implicit declaration of function 'gpio_direction_output'
>> I believe w1-gpio it has to depend on generic gpio, Ville can you
>> confirm that?
> 
> The dependency is there:
> 
> config W1_MASTER_GPIO
> 	tristate "GPIO 1-wire busmaster"
> 	depends on GENERIC_GPIO
> 
> So it looks like the arch Kconfig has selected GENERIC_GPIO but failed
> to provide the implementation.

There was a follow-up patch in the thread that limits X86_RDC321X
to X86_32 instead of any X86.

-- 
~Randy
desserts:  http://www.xenotime.net/linux/recipes/
