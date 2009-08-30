Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZH3Wzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZH3Wzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 18:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZH3Wzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 18:55:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45952 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbZH3Wzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 18:55:49 -0400
Date: Sun, 30 Aug 2009 23:55:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Mike Mohr <akihana@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: expresscard hotplug not working
Message-ID: <20090830225542.GB901@srcf.ucam.org>
References: <4746469c0908251817u225609bax66ea27261a1ef038@mail.gmail.com> <4A96819D.7060708@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A96819D.7060708@rtr.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 08:52:45AM -0400, Mark Lord wrote:

> Just create a file called /etc/modprobe.d/pciehp,
> and stick this one line into it:
>
>   options pciehp pciehp_force=1
>
> See if that works.

It's worth noting that Windows didn't support native pcie hotplug until 
Vista, and so any hardware that works with XP (ie, basically all of it, 
including Dells) is supposed to be using acpi hotplug instead. I've 
fixed one bug that led to acpiphp not working on some hardware, but if 
anyone's still running with pciehp_force=1 then please send me the 
output of acpidump so it can be fixed properly.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
