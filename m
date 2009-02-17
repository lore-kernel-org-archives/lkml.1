Return-Path: <linux-kernel-owner+w=401wt.eu-S1753587AbZBRDCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbZBRDCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 22:02:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZBRDBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 22:01:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:21704 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbZBRDBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 22:01:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,225,1233561600"; 
   d="scan'208";a="490821133"
Date: Tue, 17 Feb 2009 21:01:19 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "greg@kroah.com" <greg@kroah.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 6/7] PCI: document SR-IOV sysfs entries
Message-ID: <20090217130119.GA2427@yzhao-otc.sh.intel.com>
References: <1234790920-1810-1-git-send-email-yu.zhao@intel.com> <1234790920-1810-7-git-send-email-yu.zhao@intel.com> <20090217125021.GA2403@yzhao-otc.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217125021.GA2403@yzhao-otc.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 08:50:21PM +0800, Yu Zhao wrote:
> Hi Greg,
> 
> The `struct device' is preferred over the `struct kobject' in all cases
> that create subdirectory in sysfs, is this true?
> 
> I'd like to create a subdirectory under PCI device sysfs directory and
> put some symbol links into that directory (only symbol links). Should I
> use `device' or `kobject'? Currently I use `device' and get two extra
> file/directory (uevent and power) which look like useless for my case
> because this subdirectory doesn't reflect a real device.
> 
> I checked some code and found they use kobject_init_and_add(). Should

Oh, sorry. I meant to say kobject_create_and_add() here.

> I use it instead, or keep using the `device'?
> 
> Please advise.
> 
> Regards,
> Yu
