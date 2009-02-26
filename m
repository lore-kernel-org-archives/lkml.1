Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbZBZKBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbZBZKBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 05:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZBZKBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 05:01:25 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:33593 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZBZKBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:01:24 -0500
Message-ID: <49A66841.8020301@linux.vnet.ibm.com>
Date: Thu, 26 Feb 2009 11:00:33 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Li Wei <W.Li@Sun.COM>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
References: <49883CD7.2060602@linux.vnet.ibm.com> <1235616005.7351.8.camel@localhost>
In-Reply-To: <1235616005.7351.8.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Wei wrote:
> node->parent is always NULL, causing NULL-pointer dereference in
> remove_node.

You're right. Thanks for pointing this out - not sure how this escaped 
testing...

> Could you please include something like this?

Since a few RCs have been released since the last gcov-kernel patch 
post, I'll do a full re-post with a fix similar to the one you suggested 
included.


Regards,
   Peter Oberparleiter

