Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbZBNW3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbZBNW3l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbZBNW3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:29:34 -0500
Received: from cpsmtpo-eml01.KPNXCHANGE.COM ([213.75.38.150]:4458 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304AbZBNW3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:29:34 -0500
From: Frans Pop <elendil@planet.nl>
To: Joerg Platte <jplatte@naasa.net>
Subject: Re: cpuinfo shows wrong MHz value
Date: Sat, 14 Feb 2009 23:29:30 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200902142217.51655.jplatte@naasa.net>
In-reply-To: <200902142217.51655.jplatte@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902142329.31428.elendil@planet.nl>
X-OriginalArrivalTime: 14 Feb 2009 22:29:32.0239 (UTC) FILETIME=[B50B65F0:01C98EF3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Platte wrote:
> I'm running kernel 2.6.28.4 and /proc/cpuinfo and powertop and vmware
> are unable to detect the correct speed (1.6 GHz) of the processor:

Isn't this just the result of frequency scaling? Is the processor busy 
when you check /proc/cpuinfo?

What are the values in:
/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
?

Cheers,
FJP
