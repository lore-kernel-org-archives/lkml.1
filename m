Return-Path: <linux-kernel-owner+w=401wt.eu-S932639AbZDBQtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbZDBQtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932267AbZDBQrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:47:45 -0400
Received: from mga10.intel.com ([192.55.52.92]:8026 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932258AbZDBQro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:47:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,314,1235980800"; 
   d="scan'208";a="678228856"
Date: Thu, 2 Apr 2009 09:47:42 -0700
From: Matthew Wilcox <willy@linux.intel.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 3/5] ata: Add TRIM infrastructure
Message-ID: <20090402164742.GP2661@linux.intel.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com> <49D4DFFB.8070201@ru.mvista.com> <20090402161835.GN2661@linux.intel.com> <49D4E8B8.5000301@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D4E8B8.5000301@ru.mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 08:32:56PM +0400, Sergei Shtylyov wrote:
> Matthew Wilcox wrote:
>
>>>   I wonder where to read about the word 169 and commnand 0x06... 
>>> what's it all about?
>
>> It's in d2015r1-ATAATAPI_Command_Set_-_2_ACS-2.pdf which can be found on
>> the t13 website.
>
>    But since neither ATA/PI-7 nor ATA/PI-8 mention neither the word nor  
> command, why your validity check requires only ATA/PI-7+ compliance?

Because there are ATA-7 devices which implement this feature.
