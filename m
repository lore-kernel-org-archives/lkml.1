Return-Path: <linux-kernel-owner+w=401wt.eu-S1760835AbYCZAb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760835AbYCZAb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 20:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbYCZAbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 20:31:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55083
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754334AbYCZAbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:31:50 -0400
Date: Tue, 25 Mar 2008 17:31:46 -0700 (PDT)
Message-Id: <20080325.173146.238342309.davem@davemloft.net>
To: peterc@gelato.unsw.edu.au
Cc: clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, torvalds@linux-foundation.org,
       ianw@gelato.unsw.edu.au
Subject: Re: larger default page sizes...
From: David Miller <davem@davemloft.net>
In-Reply-To: <87od925o15.wl%peter@chubb.wattle.id.au>
References: <87tziu5q37.wl%peter@chubb.wattle.id.au>
	<20080325.164927.249210766.davem@davemloft.net>
	<87od925o15.wl%peter@chubb.wattle.id.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Chubb <peterc@gelato.unsw.edu.au>
Date: Wed, 26 Mar 2008 11:25:58 +1100

> That depends on the access pattern.

Absolutely.

FWIW, I bet it helps enormously for gcc which, even for
small compiles, swims around chaotically in an 8MB pool
of GC'd memory.
