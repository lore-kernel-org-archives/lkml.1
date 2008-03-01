Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbYCAOnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbYCAOnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 09:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYCAOnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 09:43:31 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:51004 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbYCAOna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 09:43:30 -0500
Date: Sat, 1 Mar 2008 07:43:07 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <gregkh@suse.de>
Cc: Alex Chiang <achiang@hp.com>, Gary Hade <garyhade@us.ibm.com>,
       kaneshige.kenji@jp.fujitsu.com, warthog19@eaglescrag.net,
       kristen.c.accardi@intel.com, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
Message-ID: <20080301144307.GD24386@parisc-linux.org>
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080229002938.GE21420@ldl.fc.hp.com> <20080301052542.GD19353@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301052542.GD19353@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 09:25:42PM -0800, Greg KH wrote:
> What is the guarantee that the names of these slots are correct and do
> not happen to be the same as the hotpluggable ones?

That would be a bug -- and yes, bugs happen, and we have to deal with
them.

> Why show this information on machines that can not do anything with
> these slots at all?  Will that not just confuse people?

Only for people who think that /sys/bus/pci/slots/ is for hotpluggable
slots only.  There is plenty of useful information available for slots
that aren't hotpluggable (eg bus address, speed, width, error status).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
