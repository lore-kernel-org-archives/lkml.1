Return-Path: <linux-kernel-owner+w=401wt.eu-S1759681AbXIVSCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759681AbXIVSCP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 14:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbXIVSCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 14:02:00 -0400
Received: from www.osadl.org ([213.239.205.134]:59048 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752762AbXIVSB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 14:01:59 -0400
Subject: Re: [PATCH] [9/50] i386: validate against ACPI motherboard
	resources
From: Thomas Gleixner <tglx@linutronix.de>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <ak@suse.de>,
       rajesh.shah@intel.com, jbarnes@virtuousgeek.org, greg@kroah.com,
       patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <46F542A4.9080207@shaw.ca>
References: <200709221231.836138000@suse.de>
	 <20070921223207.7BBE71479D@wotan.suse.de>
	 <86802c440709212349l3d968d1bgdc89e7c7415b54da@mail.gmail.com>
	 <46F542A4.9080207@shaw.ca>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 20:01:57 +0200
Message-Id: <1190484117.4035.71.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-22 at 10:28 -0600, Robert Hancock wrote:
> Yinghai Lu wrote:
> > No!
> > 
> > MMCONFIG will not work with acpi=off any more.
> 
> I don't think this is unreasonable. The ACPI MCFG table is how we are 
> supposed to learn about the area in the first place. If we can't get the 
> table location via an approved mechanism, and can't validate it doesn't 
> overlap with another memory reservation or something, I really don't 
> think we should be using it.

We all know how correct ACPI tables are. Specifications are nice,
reality tells a different story.

> I don't think it's much of an issue anyway - the chances that somebody 
> will want to run without ACPI on a system with MCFG are pretty low given 
> that you'll end up losing a bunch of functionality (not least of which 
> is multi-cores).

acpi=off is an often used debug switch and it _is_ quite useful. Taking
away debug functionality is not a good idea.

	tglx


