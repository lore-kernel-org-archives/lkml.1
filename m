Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbYAOKcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbYAOKcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbYAOKbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:31:48 -0500
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:56390 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755990AbYAOKbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:31:46 -0500
Date: Tue, 15 Jan 2008 11:31:43 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Steve Hardy <steve@linuxrealtime.co.uk>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 1/1] : hwmon - new chip driver for TI  ADS7828 A-D
Message-ID: <20080115113143.6a181fab@hyperion.delvare>
In-Reply-To: <20080114222849.GA7279@toshiba-lt>
References: <477D50CC.6020504@linuxrealtime.co.uk>
	<20080104073439.GA22033@toshiba-lt>
	<20080110141934.1266ee39@hyperion.delvare>
	<20080114222849.GA7279@toshiba-lt>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Mon, 14 Jan 2008 22:28:51 +0000, Steve Hardy wrote:
> > As far as I know boolean parameters take values 0 and 1, not N and Y.
> 
> Not on the systems I am testing on (2.6.24-rc6) - the sysfs interface
> displays boolean parameters as Y/N, and will accept boot parameters as
> either Y/N or 0/1.  Below is a snippet from a test proving this point :
> 
> test@shtest:~$ cat /sys/module/ads7828/parameters/se_input
> Y
> test@shtest:~$ cat /sys/module/ads7828/parameters/int_vref
> Y
> 
> after appending the ads7828.int_vref=N parameter to the kernel
> command-line :
> 
> Linux 2.6.24-rc6 (shtest) (16:53 on Saturday, 05 January 2002)
> 
> login: test
> test@shtest:~$ cat /sys/module/ads7828/parameters/int_vref
> N

Oh. This is news to me, thanks for the information.

> Is it more "correct" to refer to 1/0 in the documentation?
> I just naturally used the same syntax provided by the sysfs nodes

Nah, just scratch this comment of mine, I just didn't know that Y/N was
working for booleans. If you prefer that to document that form that's
alright with me.

(I do believe that it was a mistake to allow two different ways to do
the same thing, but that's a different issue.)

-- 
Jean Delvare
