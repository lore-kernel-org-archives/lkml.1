Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109Ab0AAVzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab0AAVzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 16:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716Ab0AAVzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 16:55:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47935 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab0AAVzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 16:55:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: davidjon@xenontk.org
Subject: Re: [Regression] 2.6.33-rc2 - pci: Commit e0cd516 causes OOPS
Date: Fri, 1 Jan 2010 22:55:28 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Rusty Russell <rusty@rustcorp.com.au>, andreas.herrmann3@amd.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4B3E51FC.9000502@xenontk.org>
In-Reply-To: <4B3E51FC.9000502@xenontk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001012255.28094.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 January 2010, David John wrote:
> Hi All,

Hi,

> Commit e0cd516 causes an null pointer dereference when reading from the
> sysfs attributes local_cpu* on Intel machines with no ACPI NUMA
> proximity info, since dev->numa_node gets set to -1 for all PCI devices,
> which then gets passed to cpumask_of_node.
> 
> The patch following this mail fixes the problem for x86. Perhaps a more
> thorough solution would be to fix the PCI layer to set the node
> information for devices to zero rather than -1 (Since if CONFIG_NUMA=y
> we have node 0)? I don't know whether it is safe / correct to do this.

First, it would be nicer if you said what the commit subject was in addition
to providing its hash.

Second, why don't you put the information above into the changelog of your
patch?

Rafael
