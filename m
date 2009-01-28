Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbZA1VG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbZA1VG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759050AbZA1VGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:06:00 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:59707 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758553AbZA1VF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:05:59 -0500
Message-ID: <4980C8A9.6090904@felter.org>
Date: Wed, 28 Jan 2009 15:05:45 -0600
From: Wes Felter <wesley@felter.org>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: dingxn@ymail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: a question about p4_clockmod module on Xeon quad core processors
References: <603382.20833.qm@web59902.mail.ac4.yahoo.com>
In-Reply-To: <603382.20833.qm@web59902.mail.ac4.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaoning Ding wrote:
> Hi list,
> 
> I have tried the p4-clockmod module in Linux kernel 2.6.29 on Xeon 5355 quad-core CPUs with no luck. It seems current p4-clockmod driver still cannot support Intel Quad core processors, right? 
> 
> I know I can also use acpi-cpufreq. It can only scale down the frequence from 2.67GHz to 2GHz. But I need some lower frequencies for some experiments.

Clock modulation is quite simple; in the past I've done it from 
userspace with /dev/cpu/*/msr or written my own module to do it. I don't 
know if I've ever tried it on quad-cores, but it worked on dual-core 
Woodcrest. (Note: I was not trying to save energy.)

Wes Felter - wesley@felter.org
