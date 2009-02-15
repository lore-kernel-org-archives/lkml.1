Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZBOACX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZBOACX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 19:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZBOACN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 19:02:13 -0500
Received: from hpsmtp-eml18.KPNXCHANGE.COM ([213.75.38.118]:45146 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752221AbZBOACN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 19:02:13 -0500
From: Frans Pop <elendil@planet.nl>
To: jplatte@naasa.net
Subject: Re: cpuinfo shows wrong MHz value
Date: Sun, 15 Feb 2009 01:02:09 +0100
User-Agent: KMail/1.9.9
Cc: Kasper Sandberg <lkml@metanurb.dk>, linux-kernel@vger.kernel.org
References: <200902142217.51655.jplatte@naasa.net> <200902142346.30449.elendil@planet.nl> <200902150022.39271.jplatte@naasa.net>
In-Reply-To: <200902150022.39271.jplatte@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902150102.11022.elendil@planet.nl>
X-OriginalArrivalTime: 15 Feb 2009 00:02:11.0515 (UTC) FILETIME=[A6A198B0:01C98F00]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009, Joerg Platte wrote:
> Sorry, I should have made it clear that my computer is running with 13
> GHz (at leat according to the kernel). With previous kernels (IIRC
> 2.6.26) cpuinfo showed the correct value.

No problem. The value that is displayed still comes from the cpu frequency 
code, so the values I asked for earlier would still be of interest.

Best to have all relevant values. Please do (as root):
# cd /sys/devices/system/cpu/cpu0/cpufreq/
# grep . *

Also, please attach your kernel config.
