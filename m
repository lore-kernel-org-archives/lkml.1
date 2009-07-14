Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbZGNJWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbZGNJWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbZGNJWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:22:05 -0400
Received: from mail-a04.ithnet.com ([217.64.83.99]:50365 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753206AbZGNJWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:22:04 -0400
X-Sender-Authentication: net64
Date: Tue, 14 Jul 2009 11:21:59 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: David Rientjes <rientjes@google.com>
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: What to do with this message (2.6.30.1) ?
Message-Id: <20090714112159.ae8b154c.skraw@ithnet.com>
In-Reply-To: <alpine.DEB.2.00.0907132247001.8784@chino.kir.corp.google.com>
References: <20090713134621.124aa18e.skraw@ithnet.com>
	<4807377b0907132240g6f74c9cbnf1302d354a0e0a72@mail.gmail.com>
	<alpine.DEB.2.00.0907132247001.8784@chino.kir.corp.google.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 22:53:29 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Mon, 13 Jul 2009, Jesse Brandeburg wrote:
> > Try increasing /proc/sys/vm/min_free_kbytes
> > 
> 
> That won't do anything but cause the failure to happen earlier because 
> GFP_HIGH will be restricted to even less ZONE_NORMAL memory.
> 
> This is a duplicate of http://bugzilla.kernel.org/show_bug.cgi?id=13648 
> which also only affects e1000.
> 
> Stephan, perhaps you can try with a CONFIG_SLUB kernel and enable both 
> CONFIG_SLUB_DEBUG and CONFIG_SLUB_DEBUG_ON?  If that doesn't reveal any 
> additional information, this sounds like a candidate for kmemleak.

I just enabled that, fortunately we can play some with this box ;-)
I will inform you tommorrow what happened.
Thanks, stay tuned.

-- 
Regards,
Stephan
