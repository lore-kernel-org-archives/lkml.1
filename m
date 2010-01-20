Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710Ab0ATEmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab0ATEmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 23:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023Ab0ATEmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 23:42:38 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:33612 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab0ATEmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 23:42:37 -0500
Date: Tue, 19 Jan 2010 23:42:29 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Alex Chiang <achiang@hp.com>
Cc: shemminger@linux-foundation.org, ming.m.lin@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: processor: only call _PDC on physically present
 processors
In-reply-to: <20100114201214.GH4545@ldl.fc.hp.com>
Message-id: <alpine.LFD.2.00.1001192340140.4265@localhost.localdomain>
References: <20100114201214.GH4545@ldl.fc.hp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple reasons to not get excited about this solution.

I don't like the processor enumeration code moving to a file called 
processor_pdc.c.

Too big for rc4 -- a logical revert to evaluate PDC when
we did in 2.6.32 would be more attractive at this point.


thanks,
Len Brown, Intel Open Source Technology Center

