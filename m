Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZBORoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZBORoP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 12:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbZBORoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 12:44:00 -0500
Received: from hpsmtp-eml20.KPNXCHANGE.COM ([213.75.38.85]:15957 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753135AbZBORn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 12:43:59 -0500
From: Frans Pop <elendil@planet.nl>
To: jplatte@naasa.net
Subject: Re: cpuinfo shows wrong MHz value
Date: Sun, 15 Feb 2009 18:43:56 +0100
User-Agent: KMail/1.9.9
References: <200902142217.51655.jplatte@naasa.net> <200902150800.59694.jplatte@naasa.net> <200902150811.36826.jplatte@naasa.net>
In-Reply-To: <200902150811.36826.jplatte@naasa.net>
Cc: Kasper Sandberg <lkml@metanurb.dk>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902151843.56875.elendil@planet.nl>
X-OriginalArrivalTime: 15 Feb 2009 17:43:58.0082 (UTC) FILETIME=[FAB44620:01C98F94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009, Joerg Platte wrote:
> Looks like p4_clockmod is responsible for these high values. After
> removing it /proc/cpuinfo shows the correct values:

Could you build your kernel with CONFIG_CPU_FREQ_DEBUG enabled and send 
the output of dmesg after a boot with p4_clockmod?
