Return-Path: <linux-kernel-owner+w=401wt.eu-S965384AbXCLJBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965384AbXCLJBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965378AbXCLJBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:01:05 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:22279 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965379AbXCLJBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:01:03 -0400
Date: Mon, 12 Mar 2007 09:58:26 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Giuliano Pochini <pochini@shiny.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /sys/devices/system/cpu/cpuX/online are missing
Message-ID: <20070312085826.GA9985@osiris.boeblingen.de.ibm.com>
References: <20070311222652.5ea40da1.pochini@shiny.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311222652.5ea40da1.pochini@shiny.it>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2007 at 10:26:52PM +0100, Giuliano Pochini wrote:
> 
> 
> Since 2.6.20 /sys/devices/system/cpu/cpuX/online isn't there anymore. The
> directories exist, though. I also tested linux-2.6.21rc3. I had a look at the
> archives and I found nothing about the removal of that file, which is still
> documented in Documentation/cpu-hotplug.txt. I don't know if other
> architectures are affected.
> 
> $ uname -a
> Linux Jay 2.6.20 #1 SMP Mon Feb 5 22:42:18 CET 2007 ppc 7455, altivec supported PowerMac3,6 GNU/Linux
> 
> No cpusets. CONFIG_HOTPLUG_CPU=y

Somebody inverted the logic when and if the 'online' attribute for cpu devices
appear. See 72486f1f8f0a2bc828b9d30cf4690cf2dd6807fc.
The fix for s390 is this: 6721f77810dfcb7cbf8e97be6fa43fe2740dd0aa.
Looks like arch/ppc was left out as well.
