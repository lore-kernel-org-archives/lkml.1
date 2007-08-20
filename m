Return-Path: <linux-kernel-owner+w=401wt.eu-S1760505AbXHTPuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505AbXHTPuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 11:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbXHTPuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:50:06 -0400
Received: from [192.55.52.93] ([192.55.52.93]:38638 "EHLO mga11.intel.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759512AbXHTPuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:50:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,285,1183359600"; 
   d="scan'208";a="285277566"
Subject: Re: [PATCH] [-mm] FS: file name must be unique in the same dir in
	procfs
From: Zhang Rui <rui.zhang@intel.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <200708201245.17780.oliver@neukum.org>
References: <1187605699.2920.147.camel@acpi-hp.sh.intel.com>
	 <200708201245.17780.oliver@neukum.org>
Content-Type: text/plain
Date: Mon, 20 Aug 2007 23:50:05 +0800
Message-Id: <1187625005.2920.167.camel@acpi-hp.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Oliver,
Thanks for your comments,

On Mon, 2007-08-20 at 18:45 +0800, Oliver Neukum wrote:
> Am Montag 20 August 2007 schrieb Zhang Rui:
> > Files name must be unique in the same directory.
> >
> > Bug is reported here:
> > http://bugzilla.kernel.org/show_bug.cgi?id=8798
> 
> Then I'd say fix the callers.
But at least the callers need to be told that something is wrong first.

>  This will paper over bugs.
Hmm, what kind of bugs?
callers always need to check the return value when calling
proc_mkdir/create_proc_entry, don't they?


Thanks,
Rui
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
