Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbXFOW5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbXFOW5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 18:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbXFOW5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 18:57:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:2869 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756747AbXFOW5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 18:57:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,426,1175497200"; 
   d="scan'208";a="257458371"
Message-ID: <4673194D.4090500@intel.com>
Date: Fri, 15 Jun 2007 15:57:17 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org>
In-Reply-To: <46731169.2090002@hawkeye.stone.uk.eu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2007 22:57:19.0454 (UTC) FILETIME=[86CCB7E0:01C7AFA0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Stone wrote:
> I hope I got the CC list right. Apologies to anyone in didn't include
> and anyone I shouldn't have included.
> 
> The basic idea is to include an idea from VMS that seems to be quite
> useful: version numbers for files.

<snip>

have you looked into ext3cow? it allows you to take snapshots of the entire ext3 
fs at a single point, and rollback / extract snapshots at any time later. This 
may be sufficient for you and the implementation seems to be rather stable already.

Cheers,

Auke


http://www.ext3cow.com/
