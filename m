Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbYCCEf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbYCCEf7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 23:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYCCEfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 23:35:51 -0500
Received: from ozlabs.org ([203.10.76.45]:38808 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbYCCEfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 23:35:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [BUILD_FAILURE] 2.6.24-git18 build fails section type conflict psmouse-base
Date: Mon, 3 Mar 2008 15:35:16 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
References: <47AC2FDB.7080104@linux.vnet.ibm.com> <20080208104851.GI7198@cs181133002.pp.htv.fi>
In-Reply-To: <20080208104851.GI7198@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031535.17644.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2008 21:48:51 Adrian Bunk wrote:
> On Fri, Feb 08, 2008 at 04:02:59PM +0530, Kamalesh Babulal wrote:
> > drivers/input/mouse/psmouse-base.c:44: error: __param_proto causes a
> > section type conflict drivers/input/mouse/psmouse-base.c:44: error:
> > __param_proto causes a section type conflict 
> @Rusty:
> Can you look at this issue? It's a modules problem on 3 architectures.
>
> cu
> Adrian
>
> [1] http://lkml.org/lkml/2007/12/27/29

Erk... This is horrible, and arguably something gcc should try to deal with.  
How about we just drop the const and add a comment, rather than breaking one 
arch at a time?

Thanks,
Rusty.


