Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbYANWas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbYANWas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757555AbYANW2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:28:55 -0500
Received: from smtp3.global.net.uk ([80.189.92.91]:58814 "EHLO
	smtp3.global.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878AbYANW2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:28:53 -0500
Date: Mon, 14 Jan 2008 22:28:51 +0000
From: Steve Hardy <steve@linuxrealtime.co.uk>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 1/1] : hwmon - new chip driver for TI  ADS7828 A-D
Message-ID: <20080114222849.GA7279@toshiba-lt>
Mail-Followup-To: Jean Delvare <khali@linux-fr.org>,
	linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
References: <477D50CC.6020504@linuxrealtime.co.uk> <20080104073439.GA22033@toshiba-lt> <20080110141934.1266ee39@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110141934.1266ee39@hyperion.delvare>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Authenticated-Sender: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> As far as I know boolean parameters take values 0 and 1, not N and Y.

Not on the systems I am testing on (2.6.24-rc6) - the sysfs interface
displays boolean parameters as Y/N, and will accept boot parameters as
either Y/N or 0/1.  Below is a snippet from a test proving this point :

test@shtest:~$ cat /sys/module/ads7828/parameters/se_input
Y
test@shtest:~$ cat /sys/module/ads7828/parameters/int_vref
Y

after appending the ads7828.int_vref=N parameter to the kernel
command-line :

Linux 2.6.24-rc6 (shtest) (16:53 on Saturday, 05 January 2002)

login: test
test@shtest:~$ cat /sys/module/ads7828/parameters/int_vref
N

Is it more "correct" to refer to 1/0 in the documentation?
I just naturally used the same syntax provided by the sysfs nodes

