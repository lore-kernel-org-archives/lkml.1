Return-Path: <linux-kernel-owner+w=401wt.eu-S934857AbXFFS3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934857AbXFFS3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbXFFS3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:29:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:12649 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949AbXFFS3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:29:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="236310343"
Message-ID: <4666FD0A.4060609@intel.com>
Date: Wed, 06 Jun 2007 11:29:30 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Josh Triplett <josh@freedesktop.org>
Subject: generic bool and sparse errors?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2007 18:29:30.0604 (UTC) FILETIME=[9F4D0AC0:01C7A868]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm experimenting with using the generic bool type and using sparse I get tons 
of these messages:

warning: incorrect type in argument 4 (different signedness)
     expected bool [unsigned] [usertype] *[unsigned] success
     got bool *<noident>

I'm not really worried about this, I assume that sparse hasn't caught up with 
what bool really means, but perhaps this can be looked into by someone who knows 
sparse well. The warnings don't really add up and with more people switching to 
use the generic bool this may beceome unwanted.

alternatively we might need to reconsider the `typedef _Bool bool;` declaration 
and force it to be unsigned. I'm not sure what to think of that.

Cheers,

Auke
