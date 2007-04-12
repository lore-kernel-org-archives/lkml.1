Return-Path: <linux-kernel-owner+w=401wt.eu-S1161519AbXDLC5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161519AbXDLC5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 22:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161533AbXDLC5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 22:57:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:52169 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161519AbXDLC5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 22:57:25 -0400
Subject: Re: [PATCH 0/12] Pass MAP_FIXED down to get_unmapped_area
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: bryan.wu@analog.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1176346589.29581.32.camel@roc-desktop>
References: <1176344427.242579.337989891532.qpush@grosgo>
	 <1176346589.29581.32.camel@roc-desktop>
Content-Type: text/plain
Date: Thu, 12 Apr 2007 12:56:19 +1000
Message-Id: <1176346579.8061.119.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there any support consideration for nommu arch such as blackfin which
> is in the -mm tree now?
> 
> It is very kind of you to point out some idea about MAP_FIXED for
> Blackfin arch, I will do some help for this.

Right now, my understanding is that nommu archs just reject MAP_FIXED
outright... we might be able to be smarter, especially if we bring a
better infrastructure which I'm still thinking about.

Ben.


