Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbZHFDbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbZHFDbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 23:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZHFDbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 23:31:16 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:36733
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545AbZHFDbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 23:31:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokBANvqeUp8qMH9/2dsb2JhbAAI1GmEGAU
X-IronPort-AV: E=Sophos;i="4.43,331,1246809600"; 
   d="scan'208";a="487902239"
Subject: RE: [PATCH] gpiolib: introduce for_each_gpio_in_chip macro
From: Ben Nizette <bn@niasdigital.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: David Brownell <david-b@pacbell.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901B7783E@mi8nycmail19.Mi8.com>
References: <200907311027.06370.hartleys@visionengravers.com>
	 <200908041414.26112.david-b@pacbell.net>
	 <BD79186B4FD85F4B8E60E381CAEE190901B7783E@mi8nycmail19.Mi8.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 13:31:20 +1000
Message-Id: <1249529480.16688.13.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 20:48 -0400, H Hartley Sweeten wrote:

> For the record. The reason I sent this is I'm trying to work out an
> extension to gpiolib that adds gpio_port_* access to the API.  Most
> of the gpiolib drivers already the necessary logic since the raw I/O
> is performed on the entire 'chip'.  The API just needs the extensions
> added to request/free the port, set the direction and get/set the value.
> 
> Is this a worthwhile addition?

Plenty of people seem to think so.  Personally I haven't seen a great
use case except "'coz I can", but if you've got one I'd love to hear.

Have you seen http://lkml.org/lkml/2009/1/25/10 ?  Donno what ended up
happening to that patchset..

	--Ben.


