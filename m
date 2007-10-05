Return-Path: <linux-kernel-owner+w=401wt.eu-S1763438AbXJEPfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763438AbXJEPfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbXJEPfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:35:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48649 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037AbXJEPfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:35:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [Q] APM depends on PM_SLEEP?
Date: Fri, 5 Oct 2007 17:49:52 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.60.0710051615350.10392@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0710051615350.10392@poirot.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710051749.52685.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 5 October 2007 16:18, Guennadi Liakhovetski wrote:
> Why does APM depend on PM_SLEEP?

Because APM uses the suspend core functions in drivers/base/power .

> So without sleep support you cannot use "Make CPU Idle calls when idle ",
> "Use real mode APM BIOS call to power off" etc? Found in 23-rc9-git of
> yesterday. 

Selecting CONFIG_SUSPEND without ACPI only causes the suspend core (used
by APM) and kernel/power/main.c to be compiled in.

Greetings,
Rafael
