Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbYGaIdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbYGaIdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 04:33:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYGaIcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 04:32:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:42649 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbYGaIco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 04:32:44 -0400
Subject: Re: [PATCH 1/2] Export get_user_pages_fast
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Avi Kivity <avi@qumranet.com>,
       Adrian Bunk <bunk@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080731012151.41733ef6.akpm@linux-foundation.org>
References: <200807301438.55941.rusty@rustcorp.com.au>
	 <48915F2F.4020407@qumranet.com>
	 <20080731000257.59830c25.akpm@linux-foundation.org>
	 <200807311810.57821.nickpiggin@yahoo.com.au>
	 <20080731012151.41733ef6.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 18:32:16 +1000
Message-Id: <1217493136.11188.433.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If we do this then corresponding changes should be made to the powerpc
> patch upon which Ben presently sits.

It's upstream :-) I had a couple of fixes to do to it, but it's
working well now and merged in the last batch.

Nick, we should look into cleaning up the fallback path too,
it's a bit ugly as it is.

Cheers,
Ben.


