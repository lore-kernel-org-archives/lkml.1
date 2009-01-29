Return-Path: <linux-kernel-owner+w=401wt.eu-S1759093AbZA2Ao5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093AbZA2Ao5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZA2Aos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 19:44:48 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:9018 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZA2Aor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 19:44:47 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=a2ekUXen0-g10LriY2kA:9 a=thZ8LmwmIvpmjRKcG9rpfqN69MQA:4 a=eMJWJUw95FcA:10
Message-ID: <4980FBFA.1010402@shaw.ca>
Date: Wed, 28 Jan 2009 18:44:42 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: akwatts@ymail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Thermal problems with newer kernels
References: <863288.78002.qm@web111002.mail.gq1.yahoo.com>
In-Reply-To: <863288.78002.qm@web111002.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Watts wrote:
> Dear Kernel Gurus:
> 
> Below is a problem that I am unable to explain along with relevant(?) info. Please let me know if I should provide additional debugging information. Thanks in advance for your assistance!
> 
> -Andy
> 
> [1] Problem: HP Pavilion zv5000 laptop idle temp is 17 degrees higher when running most recent kernels (57C versus 40C).
> 
> [2] Brief Description
> 
> Newer kernels (noticed starting with 2.6.27.3 but could have started anytime past 2.6.26.7) result in a much higher idle CPU temp. Physical temperature reading of exhaust from primary cooling fan and the regular triggering of secondary cooling fan confirms this (it is not a readout scaling issue). The kernels and temps below:
> 
> 2.6.26.7	Idle temp 40C
> 2.6.27.3	Idle temp 57C
> 2.6.28	Idle temp 57C
> 
> The only third party kernel module installed that is not part of the official kernel source is: madwifi-ng. However, the problem occurs even when this module is not loaded.
> 
> The .config file used for the newer kernels was imported from the working 2.6.26.7 .config file. 

CPU frequency scaling not working perhaps? What's your dmesg output from 
bootup look like? Is the acpi-cpufreq driver being loaded?
