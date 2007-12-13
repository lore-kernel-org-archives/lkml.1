Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbXLMNXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbXLMNXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 08:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbXLMNXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 08:23:35 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:60055 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbXLMNXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 08:23:34 -0500
Date: Thu, 13 Dec 2007 18:53:26 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: gregkh@suse.de, htejun@gmail.com, stable@kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Gautham Shenoy <ego@in.ibm.com>
Subject: Re: 2.6.22-stable causes oomkiller to be invoked
Message-ID: <20071213132326.GC16905@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071213123333.GA16905@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213123333.GA16905@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 06:03:33PM +0530, Dhaval Giani wrote:
> Hi Greg, Tejun,
> 
> The following script causes oomkiller to be invoked on my system here.
> 
> while echo; do cat /sys/kernel/kexec_crash_loaded; done
> 

 while echo; do cat /sys/kernel/uevent_seqnum ; done;

causes oomkiller to be invoked on 2.6.22-stable, 2.6.23-stable and
2.6.24-rc5 as well. It seems not be particularly related to any single
file in sysfs.

Thanks,
-- 
regards,
Dhaval
