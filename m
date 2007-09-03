Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbXICKQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbXICKQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbXICKQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:16:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:41646 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbXICKQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:16:26 -0400
From: Andi Kleen <ak@suse.de>
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access for AMD Barcelona
Date: Mon, 3 Sep 2007 12:15:03 +0200
User-Agent: KMail/1.9.1
Cc: "Robert Richter" <robert.richter@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <20070830174311.221133000@amd.com> <200709011211.52167.ak@suse.de> <20070903083242.GA22144@alberich.amd.com>
In-Reply-To: <20070903083242.GA22144@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709031215.03473.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> But it is needed for some devices for full functionality.

Examples? I can only think of PCI express error reporting, which
few drivers implement anyways and isn't really a show stopper
if it doesn't work. Besides I would be surprised if it even works
on the cheap desktop boards which have MCFG less BIOS.

> E.g. for perfmon (family 0x10/extended inerrupts) extended config space
> access is a prerequisite.

How so? 


>
> IMHO it is best to try to use MMCONFIG if it's working and to use
> a fallback (e.g. CF8 ECS access for family 0x10) if available.

We only put in workarounds if there is a serious problem otherwise (e.g. not 
booting etc.). I just don't see this here.

-Andi
