Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbXJJG0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbXJJG0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 02:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbXJJG0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 02:26:40 -0400
Received: from smile.2scale.net ([212.12.33.142]:50952 "EHLO smile.2scale.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbXJJG0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 02:26:39 -0400
Subject: Re: howto boost write(2) performance?
From: Michael Stiller <ms@2scale.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200710092025.34436.nickpiggin@yahoo.com.au>
References: <1191937817.3641.9.camel@blackberry>
	 <200710092025.34436.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Organization: 2scale GmbH
Date: Wed, 10 Oct 2007 08:26:27 +0200
Message-Id: <1191997587.3675.4.camel@blackberry>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> The kernel really cannot sustain 125MB/s? I assume the disk
> array is capable?

Yes, the array should be capable, LSI controller U320, SATA disks inside
the array. 

> Where is the bottleneck? Does it keep all disks busy, or are
> the CPUs overloaded?

I'm not sure where the bottleneck is. CPU Load goes up with 
many pdflush processes in D state.

Thanks for the suggestions with sg and O_DIRECT so far, 
will try this.

-Michael



