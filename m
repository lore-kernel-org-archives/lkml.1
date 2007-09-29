Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbXI2Hqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbXI2Hqs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 03:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbXI2Hqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 03:46:42 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:51184 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753475AbXI2Hql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 03:46:41 -0400
Message-ID: <46FE02C7.804@suse.de>
Date: Sat, 29 Sep 2007 11:46:15 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: regression in 2.6.23-rc8 - power off failed
References: <20070929005453.GA4475@erig.dyndns.org>
In-Reply-To: <20070929005453.GA4475@erig.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
This is known issue.
Please try latest rc8-git2, it should contain the fix.

Regards,
Alex.

Wolfgang Erig wrote:
> Hi,
> 
> the latest kernel does not power off my system.
> 
> 2.6.22 succeeded
> 2.6.23-rc8 failed
> 
> $ git bisect bad  
> Bisecting: 0 revisions left to test after this 
> [f216cc3748a3a22c2b99390fddcdafa0583791a2] ACPI: suspend: consolidate handling of Sx states.
> 
> Which more info is needed?
> 
> Wolfgang

