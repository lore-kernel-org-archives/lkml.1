Return-Path: <linux-kernel-owner+w=401wt.eu-S1760111AbXJLLvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbXJLLvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 07:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbXJLLvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 07:51:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47775 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbXJLLvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 07:51:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bhasker C V <bcv@unixindia.com>
Subject: Re: CPU speed after hibernation
Date: Fri, 12 Oct 2007 14:07:12 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <1192171267.6631.8.camel@h1.unixindia.com>
In-Reply-To: <1192171267.6631.8.camel@h1.unixindia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710121407.13024.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 12 October 2007 08:41, Bhasker C V wrote:
> Hi all,
> 
>  I have enable suspend-to-disk on myetch system K 2.6.21.1
>  I have enabled acpi cpu frequency scaling and using "convservative"
> governer.
> 
>  When I boot the system, the cpu frequency works switches fine based on
> the requirement. But when i go to hibernation and come back from
> hibernation, the cpu frequency gets stuck at the maximum. 
> 
>  I have already written to debian-users list but did not get any reply
> (with the same subject line). 
>  Is this a known issue ?
>  If i try to remove and re-insert the cpufreq_conservative module, the
> whole system hangs.

Please try 2.6.23.  If the problem is still there, please file a bug at
http://bugzilla.kernel.org, under "Power Management"->Hibernation/Suspend.

Greetings,
Rafael
