Return-Path: <linux-kernel-owner+w=401wt.eu-S1760294AbYCYXWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294AbYCYXWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbYCYXWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:22:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51446
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755685AbYCYXWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:22:45 -0400
Date: Tue, 25 Mar 2008 16:22:44 -0700 (PDT)
Message-Id: <20080325.162244.61337214.davem@davemloft.net>
To: clameter@sgi.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: larger default page sizes...
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0803251045510.16206@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0803241402060.7762@schroedinger.engr.sgi.com>
	<20080324.144356.104645106.davem@davemloft.net>
	<Pine.LNX.4.64.0803251045510.16206@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Tue, 25 Mar 2008 10:48:19 -0700 (PDT)

> On Mon, 24 Mar 2008, David Miller wrote:
> 
> > There are ways to get large pages into the process address space for
> > compute bound tasks, without suffering the well known negative side
> > effects of using larger pages for everything.
> 
> These hacks have limitations. F.e. they do not deal with I/O and 
> require application changes.

Transparent automatic hugepages are definitely doable, I don't know
why you think this requires application changes.

People want these larger pages for HPC apps.
