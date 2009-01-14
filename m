Return-Path: <linux-kernel-owner+w=401wt.eu-S1761212AbZANJxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212AbZANJxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbZANJw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:52:59 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:48539 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbZANJw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:52:58 -0500
Message-ID: <496DB5F9.8010001@s5r6.in-berlin.de>
Date: Wed, 14 Jan 2009 10:52:57 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Manfred Spraul <manfred@colorfullife.com>, krh@redhat.com, dcm@acm.org,
       Nadia.Derbey@bull.net, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, paulmck@us.ibm.com, stable@kernel.org
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
References: <1231571060.3538.18.camel@localhost.localdomain>	<49686465.70501@s5r6.in-berlin.de>	<20090110011557.9d94e111.akpm@linux-foundation.org>	<496872E0.9030007@s5r6.in-berlin.de>	<1231773620.6365.21.camel@gaara.bos.redhat.com>	<496B9FC7.3090108@colorfullife.com>	<1231792712.6365.31.camel@gaara.bos.redhat.com>	<496BAD1C.5060201@colorfullife.com>	<20090113144802.39dc4c23.akpm@linux-foundation.org>	<84144f020901132319g50dc9e50o283b0d263f287eea@mail.gmail.com>	<20090114001745.9575ab02.akpm@linux-foundation.org>	<496DA95B.6070401@s5r6.in-berlin.de> <20090114012234.bce79d7b.akpm@linux-foundation.org> <496DB504.8090800@s5r6.in-berlin.de>
In-Reply-To: <496DB504.8090800@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Your fix only clears idr_layers which an idr_get_new*() pulls out of the
> idr_layer_cache, but not any one which it pulls out of the idr's own
> free list.
> 
> Hmm, OK.  Seems to be harmless as long as idr users don't start to add
> new entries to an idr after they did idr_remove_all()

...on this very same idr instance.
-- 
Stefan Richter
-=====-==--= ---= -===-
http://arcgraph.de/sr/
