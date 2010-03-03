Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0CCLRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 06:17:25 -0500
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:43494 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab0CCLRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 06:17:23 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B8E45B9.7000105@cam.ac.uk>
Date: Wed, 03 Mar 2010 11:19:21 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
CC: Dima Zavin <dmitriyz@google.com>, torvalds@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
References: <4B8C1867.7040201@cam.ac.uk>	 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com> <63386a3d1003030230x2cc16e53udbacc9a5138f2872@mail.gmail.com>
In-Reply-To: <63386a3d1003030230x2cc16e53udbacc9a5138f2872@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/10 10:30, Linus Walleij wrote:
> 2010/3/3 Dima Zavin <dmitriyz@google.com>:
> 
>> how does this deal with hybrid devices?
> 
> As any hybrid device, a drivers/mfd spawns multiple sensors, als,
> accelerometer, voltage level, you name it.
> 
>> I definitely see the need for what you guys are trying to accomplish.
>> For example, currently, we use an input device for reporting events,
>> and a separate misc device node for control
>> (enable/disable/configure). It's definitely suboptimal, but there
>> currently isn't anything there would let us do things cleanly.
> 
> Are you registering your misc node from an mfd device then?
> 
>> I would love to work with you to design something more generic.
> 
> You can design forever, people need this now. (But we'd love
> to see the patches!) It's better to refactor the day something
> better is in place IMHO. Also I see no real clash. The userspace
> interface will likely be the same (input subsystem) so what's the
> problem?
> 
> In the drivers/staging/iio in the -next tree you can find something
> more generic for industrial I/O including ADCs, triggers and
> some sensors. I pointed out sometime last month that this
> has the problem of exposing only userland interfaces and no
> kernel-internal interfaces for the actual devices (just sysfs entries),
> so the current ALS subsystem cannot fit into it, for example.

We welcome patches for that as well ;)

(It is definitely on the todo list, but I'm afraid not terribly
 near the top from my point of view as I don't personally need it!)
