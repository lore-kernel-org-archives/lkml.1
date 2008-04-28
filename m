Return-Path: <linux-kernel-owner+w=401wt.eu-S934958AbYD1Row@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934958AbYD1Row (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932607AbYD1Ron
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:44:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:19629 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765875AbYD1Rom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:44:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,717,1199692800"; 
   d="scan'208";a="322230425"
Message-ID: <48160CBA.4010504@intel.com>
Date: Mon, 28 Apr 2008 10:43:22 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080417)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, viro@ZenIV.linux.org.uk
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH] e1000e triggers sparc32 gcc bug
References: <20080427051541.GN5882@ZenIV.linux.org.uk> <20080426.221908.193700782.davem@davemloft.net>
In-Reply-To: <20080426.221908.193700782.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Apr 2008 17:44:41.0319 (UTC) FILETIME=[8970F770:01C8A957]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Al Viro <viro@ZenIV.linux.org.uk>
> Date: Sun, 27 Apr 2008 06:15:42 +0100
> 
>> 	... and isn't possible on sparc32 boxen anyway, unless somebody
>> had done JavaStation with PCIE lately.
>>
>> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Acked-by: David S. Miller <davem@davemloft.net>
> 
> Unfortunately this is necessary, every gcc I've tried triggers
> a reload bug on 32-bit sparc.
> 
> Meanwhile I'll try and get the gcc bug fixed.
> 
> Thanks Al.

wow, that's pretty bad - anything I can do? We're severely limited in sparc
systems here...

Auke

