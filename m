Return-Path: <linux-kernel-owner+w=401wt.eu-S1764049AbZANQV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764049AbZANQV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbZANQVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:21:48 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:49774 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887AbZANQVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:21:48 -0500
Message-ID: <496E111A.9010808@s5r6.in-berlin.de>
Date: Wed, 14 Jan 2009 17:21:46 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Manfred Spraul <manfred@colorfullife.com>, dcm@acm.org,
       Nadia.Derbey@bull.net, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, paulmck@us.ibm.com
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
References: <1231571060.3538.18.camel@localhost.localdomain>	 <49686465.70501@s5r6.in-berlin.de>	 <20090110011557.9d94e111.akpm@linux-foundation.org>	 <496872E0.9030007@s5r6.in-berlin.de>	 <1231773620.6365.21.camel@gaara.bos.redhat.com>	 <496B9FC7.3090108@colorfullife.com>	 <1231792712.6365.31.camel@gaara.bos.redhat.com>	 <496BAD1C.5060201@colorfullife.com>	 <20090113144802.39dc4c23.akpm@linux-foundation.org> <1231942990.8542.7.camel@gaara.bos.redhat.com>
In-Reply-To: <1231942990.8542.7.camel@gaara.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> On Tue, 2009-01-13 at 14:48 -0800, Andrew Morton wrote:
>> What do we think of just removing the constructor and using
>> kmem_cache_zalloc()?
> 
> We still need to zero out the idr_layer before returning it to the idr's
> internal free list.

I think so too.  But a more robust solution would IMO be to initialize
an idr_layer /before/ use, not /after/ use.  Will send a patch later.
-- 
Stefan Richter
-=====-==--= ---= -===-
http://arcgraph.de/sr/
