Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbYFZD61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbYFZD61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 23:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbYFZD6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 23:58:17 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:51357 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbYFZD6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 23:58:17 -0400
Date: Wed, 25 Jun 2008 23:57:54 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI: add standard linux WARN() output to ACPI warnings
In-reply-to: <alpine.LFD.1.10.0806242310000.3014@localhost.localdomain>
X-X-Sender: lenb@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Zhao Yakui <yakui.zhao@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Message-id: <alpine.LFD.1.10.0806252357300.3279@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20080620095247.GA24557@elte.hu>
 <20080620135639.GA5073@damson.getinternet.no> <20080620142224.GF8135@elte.hu>
 <alpine.LFD.1.10.0806242231120.3014@localhost.localdomain>
 <20080624194915.11d6aee9@infradead.org>
 <alpine.LFD.1.10.0806242310000.3014@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jun 2008, Len Brown wrote:

> 
> 
> > Please do not use warn_on_slowpath() directly!
> > Please use WARN_ON() or WARN(). The later has printk semantics so this
> > could turn into
> > 
> > WARN(1, "ACPI Error (%s-%0d): \n", module_name, line_number);
> 
> > 
> > and kerneloops.org and various other tools will pick up the printk like
> > arguments as part of the warning message.
> 
> cool, will do.

that is, will do when WARN() actually gets upstream:-)
